import { NullableType } from './../utils/types/nullable.type';
import {
  BadRequestException,
  ForbiddenException,
  Inject,
  Injectable,
  NotFoundException,
  UnauthorizedException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { UsersService } from '../users/users.service';
import { LoginResponseType } from './types/login-response.type';
import { AuthEmailLoginDto } from './dto/auth-email-login.dto';
import { compare } from 'bcrypt';
import { UserEntity } from '../users/entity/user';
import ms from 'ms';
import { randomBytes } from 'crypto';

import { AuthEmailRegisterDto } from './dto/auth-email-register.dto';

import Logger, { LoggerKey } from '../logging/types/logger.type';
import { SessionService } from '../session/session.service';
import { EnvService } from '../env/env.service';
import { MailService } from '../mail/mail.service';
import { SocialInterface } from '../social/social.interface';
import { VerificationRepository } from './verification.repository';
import { UserSelect } from '../database/interfaces';

@Injectable()
export class AuthService {
  constructor(
    private jwtService: JwtService,
    private usersService: UsersService,
    private envService: EnvService,
    private sessionService: SessionService,
    private mailService: MailService,
    @Inject(LoggerKey) private logger: Logger,
    private readonly verificationRepository: VerificationRepository,
  ) {}

  async validateLogin(loginDto: AuthEmailLoginDto): Promise<LoginResponseType> {
    this.logger.debug(`Validating login for ${loginDto.email}`);

    const user = await this.usersService.findOne(loginDto.email);

    // Check if the user exists and the password is valid even if the user does not exist to prevent timing attacks
    const usersPassword = user ? (user.password ? user.password : '') : '';

    const isValidPassword = await this.validatePassword(
      loginDto.password,
      usersPassword,
    );

    if (!user) {
      this.logger.warn(`User not found with this email: ${loginDto.email}`);
      throw new UnauthorizedException(
        'Email ya da şifre hatalı! Lütfen tekrar deneyiniz.',
      );
    }

    if (!isValidPassword) {
      this.logger.warn(
        `Invalid password for user with email: ${loginDto.email}`,
      );
      throw new UnauthorizedException(
        'Email ya da şifre hatalı! Lütfen tekrar deneyiniz.',
      );
    }

    if (!user.password) {
      this.logger.warn(
        `User registered with ${user.provider} provider, not allowed to login with email and password`,
      );
      throw new ForbiddenException(
        'Daha önce bu e-posta adresi ile başka bir yöntemle kayıt olmuşsunuz. Lütfen diğer yöntemlerle giriş yapmayı deneyin.',
      );
    }

    const userInfo = await this.usersService.getUserInfo(user.id);

    if (!userInfo) {
      this.logger.error(
        `User info not found for user with email: ${loginDto.email}`,
      );
      throw new NotFoundException('Kullanıcı bilgileri bulunamadı');
    }

    const tokens = await this.generateTokens(user);
    await this.sessionService.createSession({
      userId: user.id,
      token: tokens.refreshToken,
      expiresAt: new Date(tokens.tokenExpires),
    });

    return {
      token: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      tokenExpires: tokens.tokenExpires,
      user: userInfo,
    };
  }

  async validateRegister({ email, password, username }: AuthEmailRegisterDto) {
    const user = await this.usersService.checkIfUserExists(username, email);
    if (user && user.exists) {
      throw new UnprocessableEntityException(
        'Bu email adresi ya da kullanıcı adı kullanılmaktadır.',
      );
    } else {
      this.logger.debug(`Creating user with email: ${email}`);
      const user = await this.usersService.create({
        email,
        password,
        username,
      });
      if (!user) {
        throw new UnprocessableEntityException('Kullanıcı oluşturulamadı');
      }
      const validationCode = this.createValidationCode();
      await this.createVerificationRequest(user.id, validationCode);
      this.logger.info('Verification email will be sent to user', {
        props: {
          id: user.id,
        },
      });
      await this.mailService.userSignUp({
        to: email,
        data: {
          name: username,
          validationCode,
        },
      });
      const userInfo = await this.usersService.getUserInfo(user.id);
      if (!userInfo) {
        throw new NotFoundException('Kullanıcı bilgileri bulunamadı');
      }
      this.logger.debug(`User created with email: ${email}`);
      this.logger.info('User created', {
        props: {
          id: user.id,
        },
      });

      const tokens = await this.generateTokens(user);
      await this.sessionService.createSession({
        userId: user.id,
        token: tokens.refreshToken,
        expiresAt: new Date(tokens.tokenExpires),
      });

      return {
        token: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        tokenExpires: tokens.tokenExpires,
        user: userInfo,
      };
    }
  }

  async verifyEmail(code: string, userId: string, token: string) {
    this.logger.debug('Verifying email');
    const user = await this.usersService.getUserInfo(userId);
    if (!user) {
      this.logger.warn('User not found', {
        props: {
          userId,
        },
      });
      throw new NotFoundException('Kullanıcı bulunamadı');
    }
    if (user.emailVerified) {
      this.logger.warn('Email already verified', {
        props: {
          userId,
        },
      });
      throw new UnprocessableEntityException('Email zaten doğrulanmış');
    }
    const verificationRequest = await this.getVerificationRequest(userId);
    if (!verificationRequest) {
      this.logger.warn('Verification request not found', {
        props: {
          userId,
        },
      });
      throw new NotFoundException('Doğrulama isteği bulunamadı');
    }
    if (verificationRequest.code !== code) {
      this.logger.warn('Invalid verification code', {
        props: {
          userId,
        },
      });
      throw new BadRequestException('Doğrulama kodu hatalı');
    }
    if (verificationRequest.expires < new Date()) {
      this.logger.warn('Verification code expired', {
        props: {
          userId,
        },
      });
      throw new BadRequestException('Doğrulama kodunun süresi dolmuş');
    }

    const userInfo = await this.usersService.updateUser({
      id: user.id,
      emailVerified: true,
    });

    if (!userInfo) {
      throw new NotFoundException('Kullanıcı bilgileri bulunamadı');
    }
    this.logger.info('email verified for user', {
      props: {
        userId,
      },
    });
    await this.approveVerificationRequest(userId);

    this.logger.debug('email verified successfully', {
      props: {
        userId,
      },
    });

    const tokens = await this.refresh(token);

    return {
      token: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      tokenExpires: tokens.tokenExpires,
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
        emailVerified: true,
        role: user.role,
        avatarPath: user.avatarPath,
      },
    };
  }

  async resendEmailVerification(userId: string) {
    this.logger.info('Resending email verification', {
      props: {
        userId,
      },
    });
    const user = await this.usersService.getUserInfo(userId);
    if (!user) {
      this.logger.warn('User not found', {
        props: {
          userId,
        },
      });
      throw new NotFoundException('Kullanıcı bulunamadı');
    }
    if (user.emailVerified) {
      this.logger.warn('Email already verified', {
        props: {
          userId,
        },
      });
      throw new UnprocessableEntityException('Email zaten doğrulanmış');
    }
    const verificationRequest = await this.getVerificationRequest(userId);

    if (verificationRequest?.status === 'APPROVED') {
      this.logger.warn('Verification request already approved', {
        props: {
          userId,
        },
      });
      throw new UnprocessableEntityException('Email zaten doğrulanmış');
    }

    if (
      verificationRequest &&
      verificationRequest.retry > 3 &&
      verificationRequest.expires > new Date()
    ) {
      this.logger.warn('Verification request limit exceeded', {
        props: {
          userId,
          retry: verificationRequest.retry,
          expires: verificationRequest.expires,
        },
      });
      const minutesLeft = Math.ceil(
        (verificationRequest.expires.getTime() - Date.now()) / 60000,
      );
      throw new BadRequestException(
        `Doğrulama kodu gönderme hakkınız doldu. Lütfen ${minutesLeft} dakika sonra tekrar deneyin.`,
      );
    }
    const validationCode = this.createValidationCode();
    await this.createVerificationRequest(userId, validationCode);
    this.logger.info('Verification email will be sent to user', {
      props: {
        userId,
        retry: verificationRequest?.retry || 1,
      },
    });
    await this.mailService.userSignUp({
      to: user.email,
      data: {
        name: user.username,
        validationCode,
      },
    });
    return {
      message: 'Doğrulama kodu başarıyla gönderildi',
      status: 'success',
    };
  }

  createValidationCode() {
    let code: string;
    do {
      code = Math.floor(100000 + Math.random() * 900000).toString();
    } while (
      /(\d)\1{2,}/.test(code) || // Check for more than two consecutive same digits
      /^(.)\1*$/.test(code) || // Check if all digits are the same
      ['123456', '654321'].includes(code) // Check for simple sequences
    );
    return code;
  }

  async createVerificationRequest(userId: string, code: string) {
    await this.verificationRepository.upsertVerificationRequest(userId, code);
  }

  async approveVerificationRequest(userId: string) {
    await this.verificationRepository.approveVerificationRequest(userId);
  }

  async getVerificationRequest(userId: string) {
    return await this.verificationRepository.getVerificationRequest(userId);
  }

  async validatePassword(
    password: string,
    userPassword: string,
  ): Promise<boolean> {
    return await compare(password, userPassword);
  }

  async me(id: UserEntity['id']) {
    const user = await this.usersService.getUserInfo(id);
    if (!user) {
      throw new NotFoundException('Kullanıcı bulunamadı');
    }
    return user;
  }

  async generateTokens(data: {
    id: UserEntity['id'];
    email: UserEntity['email'];
    role: UserEntity['role'];
    emailVerified: UserEntity['emailVerified'];
  }) {
    const payload = {
      email: data.email,
      id: data.id,
      role: data.role,
      emailVerified: data.emailVerified,
    };
    const tokenExpiresIn = this.envService.get(
      'JWT_ACCESS_TOKEN_EXPIRATION_TIME',
    );

    const tokenExpires = Date.now() + ms(tokenExpiresIn);

    const accessToken = await this.jwtService.signAsync(payload, {
      expiresIn: tokenExpiresIn,
      secret: this.envService.get('JWT_SECRET'),
    });

    const refreshToken = randomBytes(64).toString('hex');
    this.logger.debug(
      `Generated access token for user with email: ${data.email}`,
    );
    return {
      accessToken,
      refreshToken,
      tokenExpires,
    };
  }

  async refresh(token: string) {
    const session = await this.sessionService.getSession(token);
    if (!session) {
      this.logger.debug(`Session not found for token: ${token}`);
      throw new NotFoundException('Oturum bulunamadı');
    }
    const user = await this.usersService.getUserInfo(session.userId);
    if (!user) {
      throw new NotFoundException('Kullanıcı bulunamadı');
    }
    const tokens = await this.generateTokens(user);
    await this.sessionService.updateSession({
      id: session.id,
      token: tokens.refreshToken,
      expiresAt: new Date(tokens.tokenExpires),
    });
    this.logger.debug(`Refreshed token for user with email: ${user.email}`);
    return tokens;
  }

  async logout(token: string) {
    const session = await this.sessionService.getSession(token);
    if (!session) {
      this.logger.debug(`Session not found for token: ${token}`);
      throw new NotFoundException('Oturum bulunamadı');
    }
    await this.sessionService.deleteSession(token);
  }

  async validateGoogleLogin(
    googleData: SocialInterface,
  ): Promise<LoginResponseType> {
    let user: NullableType<UserSelect> = null;
    const googleEmail = googleData.email?.toLowerCase();
    let userByEmail: NullableType<UserSelect> = null;
    if (!googleEmail) {
      this.logger.warn('Invalid Google data received', {
        props: {
          id: googleData.id,
        },
      });
      throw new BadRequestException(
        'Hatalı Google verisi alındı. Lütfen tekrar deneyin.',
      );
    }
    userByEmail = await this.usersService.findOne(googleEmail);
    user = await this.usersService.findOneBySocialId(googleData.id, 'GOOGLE');

    if (user) {
      this.logger.debug(`User found with google id: ${googleData.id}`);
      if (googleEmail && !userByEmail) {
        this.logger.debug('Updating user email with google email');
        await this.usersService.updateUser({
          ...user,
          email: googleEmail,
          emailVerified: true,
        });
      }
    } else if (userByEmail) {
      this.logger.debug(`User found with email: ${googleEmail}`);
      await this.usersService.updateUser({
        ...userByEmail,
        socialId: googleData.id,
        provider: 'GOOGLE',
        emailVerified: true,
      });
      user = userByEmail;
    } else {
      this.logger.debug(`Creating user with google email: ${googleEmail}`);
      const googleName = googleEmail.split('@')[0];
      const checkNameExists =
        await this.usersService.checkIfUserExists(googleName);
      user = await this.usersService.createSocialUser({
        email: googleEmail,
        socialId: googleData.id,
        provider: 'GOOGLE',
        name:
          checkNameExists && checkNameExists.exists ? googleEmail : googleName,
      });
    }

    const userInfo = await this.usersService.getUserInfo(user.id);
    if (!userInfo) {
      throw new UnprocessableEntityException('Kullanıcı bilgileri bulunamadı');
    }

    const tokens = await this.generateTokens(user);
    await this.sessionService.createSession({
      userId: user.id,
      token: tokens.refreshToken,
      expiresAt: new Date(tokens.tokenExpires),
    });

    return {
      token: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      tokenExpires: tokens.tokenExpires,
      user: userInfo,
    };
  }
}

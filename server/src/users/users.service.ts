import {
  Inject,
  Injectable,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { hash, genSalt } from 'bcrypt';
import Logger, { LoggerKey } from '../logging/types/logger.type';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import crypto from 'crypto';
import { MailService } from '../mail/mail.service';
import { UserProfileEntity } from './entity/user-profile';
import { UpdateUserProfileDto } from './dto/update-user-profile.dto';
import { S3Service } from '../s3/s3.service';
import { UsersRepository } from './users.repository';
import { AuthEmailRegisterDto } from '../auth/dto/auth-email-register.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { provider } from '../database/enums';
@Injectable()
export class UsersService {
  constructor(
    private mailService: MailService,
    private s3Service: S3Service,
    @Inject(LoggerKey) private logger: Logger,
    private readonly usersRepository: UsersRepository,
  ) {}
  async findOne(email: string) {
    return this.usersRepository.findByOneEmail(email);
  }

  async getUserInfo(id: string) {
    const userInfo = await this.usersRepository.getUserInfo(id);

    if (!userInfo) {
      throw new NotFoundException('Kullanıcı bulunamadı.');
    }

    return {
      ...userInfo,
      avatarPath: userInfo.avatarPath
        ? await this.s3Service.createPresignedUrl(userInfo.avatarPath)
        : null,
    };
  }

  async findOneBySocialId(socialId: string, provider: provider) {
    return await this.usersRepository.findOneBySocialId(socialId, provider);
  }

  async updateUser(user: UpdateUserDto & { id: string }) {
    this.logger.info('Updating user', {
      props: {
        id: user.id,
        verified: user.emailVerified,
      },
    });
    return this.usersRepository.updateUser(user);
  }

  async create({ email, password, username }: AuthEmailRegisterDto) {
    const saltRounds = 10;
    const hashedPassword = await genSalt(saltRounds).then((salt) =>
      hash(password, salt),
    );
    return this.usersRepository.createUser({
      email,
      password: hashedPassword,
      username,
    });
  }

  async forgotPassword({ email }: ForgotPasswordDto) {
    const user = await this.usersRepository.getUserWithPasswordResetData(email);
    if (user) {
      this.logger.info('Password reset requested', {
        props: {
          userId: user.id,
        },
      });
      this.logger.debug('Checking password reset request status', {
        props: {
          password: user.passwordReset,
        },
      });
      if (!user.passwordReset) {
        this.logger.debug('Creating password reset request');
        await this.resetPassword(user.id, user.email, user.username);
      } else if (
        new Date(user.passwordReset.expires) < new Date() ||
        (new Date(user.passwordReset.expires) > new Date() &&
          user.passwordReset.retry < 3)
      ) {
        this.logger.debug('Resetting password reset request');
        await this.resetPassword(user.id, user.email, user.username);
      } else if (user.passwordReset.status === 'APPROVED') {
        this.logger.debug('Resetting password reset request');
        await this.resetPassword(user.id, user.email, user.username);
      }
    }

    return {
      message:
        'Eğer bu e-posta adresi sistemimizde kayıtlı ise, size bir e-posta gönderdik. Lütfen e-posta adresinizi kontrol edin.',
      status: 'success',
    };
  }

  async resetPassword(userId: string, email: string, name: string) {
    const token = crypto.randomBytes(16).toString('hex');
    const expires = new Date(
      new Date().setUTCHours(new Date().getUTCHours() + 1),
    );
    await this.usersRepository.upsertResetPassword(userId, token, expires);
    this.logger.info('Password reset request email will be sent', {
      props: {
        userId,
      },
    });
    await this.mailService.forgotPassword({
      to: email,
      data: {
        name,
        token,
      },
    });
    this.logger.debug('Password reset request email sent', {
      props: {
        userId,
      },
    });
  }

  async resetPasswordConfirm(token: string, password: string) {
    const reset =
      await this.usersRepository.getUserPasswordResetDataWithToken(token);
    if (!reset) {
      this.logger.error('Invalid token');
      throw new NotFoundException('Geçersiz istek. Lütfen tekrar deneyin.');
    }
    if (reset.expires < new Date()) {
      this.logger.error('Expired token', {
        props: {
          userId: reset.userId,
        },
      });
      throw new UnprocessableEntityException(
        'Geçersiz istek. Lütfen tekrar deneyin.',
      );
    }
    if (reset.status !== 'PENDING') {
      this.logger.error('Password reset status is not pending', {
        props: {
          userId: reset.userId,
        },
      });
      throw new UnprocessableEntityException(
        'Geçersiz istek. Lütfen tekrar deneyin.',
      );
    }
    if (reset && reset.expires > new Date()) {
      const saltRounds = 10;
      const hashedPassword = await genSalt(saltRounds).then((salt) =>
        hash(password, salt),
      );
      await this.usersRepository.updateUser({
        password: hashedPassword,
        id: reset.userId,
      });
      await this.usersRepository.approvePasswordResetRequest(reset.id);
      this.logger.info('Password reset request approved', {
        props: {
          userId: reset.userId,
        },
      });
      return {
        message:
          'Şifreniz başarıyla değiştirildi. Yeni şifrenizle giriş yapabilirsiniz.',
        status: 'success',
      };
    }
  }

  async createSocialUser({
    email,
    socialId,
    provider,
    name,
  }: {
    email: string;
    socialId: string;
    provider: provider;
    name: string;
  }) {
    this.logger.info('Creating social user', {
      props: {
        provider,
      },
    });
    return this.usersRepository.createSocialUser({
      email,
      socialId,
      provider,
      username: name,
    });
  }

  async updateUserProfile(profile: UpdateUserProfileDto, userId: string) {
    this.logger.debug('profile', {
      props: {
        profile,
      },
    });
    this.logger.info('Creating user profile', {
      props: {
        userId,
      },
    });

    const profileInfo = await this.usersRepository.updateUserProfile(
      userId,
      profile,
    );

    if (!profileInfo) {
      throw new NotFoundException('Kullanıcı bulunamadı.');
    }

    this.logger.info('User profile updated', {
      props: {
        userId,
      },
    });

    return new UserProfileEntity(profileInfo);
  }

  async checkIfUserExists(username: string, email?: string) {
    return this.usersRepository.userExistsByUsername(username, email);
  }

  async getCurrentUserProfile(userId: string) {
    const profile = await this.usersRepository.getUserProfile(userId);

    if (!profile) {
      throw new NotFoundException('Kullanıcı profil bilgisi bulunamadı.');
    }
    return new UserProfileEntity(profile);
  }

  async createUploadProfilePicturePresignedPost(userId: string) {
    // TODO: Implement rate limiting for profile picture uploads

    this.logger.info('Creating upload profile picture presigned post', {
      props: {
        userId,
      },
    });

    const user = await this.usersRepository.getUserAvatarUpdateAt(userId);

    if (!user) {
      throw new NotFoundException('Kullanıcı bulunamadı.');
    }

    // check if avatar recently updated
    if (
      user.avatarUpdatedAt !== null &&
      user.avatarUpdatedAt !== undefined &&
      user.avatarUpdatedAt > new Date(Date.now() - 1000 * 60 * 5)
    ) {
      const timeDifference =
        user.avatarUpdatedAt.getTime() - (Date.now() - 1000 * 60 * 5);
      throw new UnprocessableEntityException(
        `Profil resminizi yeni güncellediniz. Lütfen ${(timeDifference / 1000).toFixed(0)} saniye sonra tekrar deneyin.`,
      );
    }

    await this.usersRepository.updateUser({
      id: userId,
      avatarUploadRequestedAt: new Date(),
    });

    return await this.s3Service.createPresignedPost(
      `profile-pictures/${userId}`,
    );
  }

  async saveUploadedProfilePicture(userId: string, key: string) {
    this.logger.info('Saving uploaded profile picture', {
      props: {
        userId,
        key,
      },
    });

    if (
      key.split('/')[0] !== 'profile-pictures' ||
      key.split('/')[1] !== userId
    ) {
      throw new UnprocessableEntityException();
    }

    const user = await this.usersRepository.getUserAvatarInfo(userId);

    if (!user) {
      throw new NotFoundException('Kullanıcı bulunamadı.');
    }

    if (
      user.avatarUploadRequestedAt === null ||
      user.avatarUploadRequestedAt < new Date(Date.now() - 1000 * 60)
    ) {
      throw new UnprocessableEntityException(
        'Profil resmi yükleme talebi bulunamadı.',
      );
    }

    if (user.avatarPath) {
      return;
    }
    const isFileExist = await this.s3Service.checkFileExists(key);

    if (!isFileExist) {
      throw new NotFoundException('Fotoğraf bulunamadı.');
    }

    await this.usersRepository.updateUser({
      id: userId,
      avatarPath: key,
      avatarUpdatedAt: new Date(),
      avatarUploadRequestedAt: null,
    });

    this.logger.info('Profile picture saved', {
      props: {
        userId,
        key,
      },
    });

    const url = await this.s3Service.createPresignedUrl(key);

    return {
      url,
    };
  }
}

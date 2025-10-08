import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Inject,
  Post,
  Put,
  Req,
  Res,
  SerializeOptions,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import {
  ApiBadRequestResponse,
  ApiBody,
  ApiCookieAuth,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiTags,
  OmitType,
} from '@nestjs/swagger';
import { AuthEmailLoginDto } from './dto/auth-email-login.dto';
import { Response, Request } from 'express';

import ms from 'ms';
import { AuthEntity } from './entity/auth.entity';
import { AuthEmailRegisterDto } from './dto/auth-email-register.dto';
import { AuthGuard } from '@nestjs/passport';
import { Logger } from 'winston';
import { LoggerKey } from '../logging/types/logger.type';
import { ResponseErrorDto } from '../common/dto/response-error.dto';
import { RefreshGuard } from '../common/guards/refresh.guard';
import { Cookies } from '../common/decorators/cookie.decorator';
import { EnvService } from '../env/env.service';
import { UserInfo } from '../users/entity/user-info';
import { GeneralResponseDto } from '../common/dto/general-response.dto';
import { AuthConfirmEmailDto } from './dto/auth-confirm-email.dto';
import { UserEntity } from '../users/entity/user';

@ApiTags('Auth')
@Controller({
  path: 'auth',
  version: '1',
})
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly envService: EnvService,
    @Inject(LoggerKey) private logger: Logger,
  ) {}

  @Post('email/')
  @ApiCreatedResponse({
    type: AuthEntity,
    status: HttpStatus.CREATED,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @ApiBody({
    type: AuthEmailLoginDto,
    examples: {
      default: {
        value: {
          email: 'biberonapp@gmail.com',
          password: 'password',
        },
      },
    },
  })
  @SerializeOptions({ groups: ['me'] })
  public async login(
    @Res({ passthrough: true }) res: Response,
    @Body() loginDto: AuthEmailLoginDto,
  ) {
    const { refreshToken, token, tokenExpires, user } =
      await this.authService.validateLogin(loginDto);
    res.cookie('refresh_token', refreshToken, {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
      maxAge: ms(this.envService.get('REFRESH_TOKEN_EXPIRATION_TIME')),
    });
    res.cookie('access_token', token, {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
      maxAge: ms(this.envService.get('JWT_ACCESS_TOKEN_EXPIRATION_TIME')),
    });

    return new AuthEntity({
      refreshToken,
      token,
      expiresAt: new Date(tokenExpires),
      user,
    });
  }

  @Post('email/new')
  @ApiCreatedResponse({
    status: HttpStatus.CREATED,
    type: GeneralResponseDto,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  @SerializeOptions({ groups: ['me'] })
  public async register(
    @Res({ passthrough: true }) res: Response,
    @Body() registerDto: AuthEmailRegisterDto,
  ) {
    const { refreshToken, token, tokenExpires, user } =
      await this.authService.validateRegister(registerDto);
    res.cookie('refresh_token', refreshToken, {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
      maxAge: ms(this.envService.get('REFRESH_TOKEN_EXPIRATION_TIME')),
    });
    res.cookie('access_token', token, {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
      maxAge: ms(this.envService.get('JWT_ACCESS_TOKEN_EXPIRATION_TIME')),
    });

    return new AuthEntity({
      refreshToken,
      token,
      expiresAt: new Date(tokenExpires),
      user,
    });
  }

  @Get('me')
  @ApiCookieAuth()
  @ApiOkResponse({
    type: UserInfo,
    status: HttpStatus.OK,
  })
  @UseGuards(AuthGuard('jwt'))
  @SerializeOptions({ groups: ['me'] })
  async me(@Req() req: Request) {
    return new UserEntity(await this.authService.me(req.user.id));
  }

  @Post('session')
  @ApiCookieAuth()
  @ApiCreatedResponse({
    type: OmitType(AuthEntity, ['user']),
    status: HttpStatus.OK,
  })
  @UseGuards(RefreshGuard)
  @HttpCode(HttpStatus.OK)
  async refresh(
    @Res({ passthrough: true }) res: Response,
    @Cookies('refresh_token') token: string,
  ) {
    const tokens = await this.authService.refresh(token);
    res.cookie('refresh_token', tokens.refreshToken, {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
      maxAge: ms(this.envService.get('REFRESH_TOKEN_EXPIRATION_TIME')),
    });

    res.cookie('access_token', tokens.accessToken, {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
      maxAge: ms(this.envService.get('JWT_ACCESS_TOKEN_EXPIRATION_TIME')),
    });

    return new AuthEntity({
      refreshToken: tokens.refreshToken,
      token: tokens.accessToken,
      expiresAt: new Date(tokens.tokenExpires),
    });
  }

  @Delete('session')
  @ApiCookieAuth()
  @ApiOkResponse({
    status: HttpStatus.OK,
    type: GeneralResponseDto,
  })
  @UseGuards(RefreshGuard)
  @HttpCode(HttpStatus.OK)
  async logout(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
    @Cookies('refresh_token') token: string,
  ) {
    this.logger.debug('req.cookies', req.cookies);
    await this.authService.logout(token);
    res.clearCookie('access_token', {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
    });
    res.clearCookie('refresh_token', {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
    });
    return {
      message: 'Başarıyla çıkış yapıldı',
      status: 'success',
    };
  }

  @Post('verify')
  @ApiCreatedResponse({
    status: HttpStatus.OK,
    type: AuthEntity,
  })
  @UseGuards(AuthGuard('jwt'), RefreshGuard)
  @SerializeOptions({ groups: ['me'] })
  async verifyEmail(
    @Req() req: Request,
    @Body() verifyDto: AuthConfirmEmailDto,
    @Cookies('refresh_token') token: string,
    @Res({ passthrough: true }) res: Response,
  ) {
    const {
      refreshToken,
      token: AccessToken,
      tokenExpires,
      user,
    } = await this.authService.verifyEmail(verifyDto.code, req.user.id, token);
    res.cookie('refresh_token', refreshToken, {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
      maxAge: ms(this.envService.get('REFRESH_TOKEN_EXPIRATION_TIME')),
    });
    res.cookie('access_token', AccessToken, {
      domain:
        this.envService.get('NODE_ENV') === 'production'
          ? this.envService.get('COOKIE_DOMAIN')
          : undefined,
      httpOnly: true,
      secure: this.envService.get('NODE_ENV') === 'production',
      maxAge: ms(this.envService.get('JWT_ACCESS_TOKEN_EXPIRATION_TIME')),
    });

    return new AuthEntity({
      refreshToken,
      token: AccessToken,
      expiresAt: new Date(tokenExpires),
      user,
    });
  }

  @Put('verify')
  @ApiOkResponse({
    status: HttpStatus.OK,
    type: GeneralResponseDto,
  })
  @UseGuards(AuthGuard('jwt'))
  async resendEmailVerification(@Req() req: Request) {
    return this.authService.resendEmailVerification(req.user.id);
  }
}

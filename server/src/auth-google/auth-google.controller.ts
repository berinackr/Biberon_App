import {
  Body,
  Controller,
  HttpStatus,
  Post,
  Res,
  SerializeOptions,
} from '@nestjs/common';
import { AuthGoogleService } from './auth-google.service';
import {
  ApiBadRequestResponse,
  ApiCreatedResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AuthService } from 'src/auth/auth.service';
import { AuthGoogleLoginDto } from './dto/auth-google-login.dto';
import { EnvService } from 'src/env/env.service';
import { Response } from 'express';
import ms from 'ms';
import { AuthEntity } from 'src/auth/entity/auth.entity';
import { ResponseErrorDto } from 'src/common/dto/response-error.dto';

@ApiTags('Auth')
@Controller({
  path: 'auth/google',
  version: '1',
})
export class AuthGoogleController {
  constructor(
    private readonly authGoogleService: AuthGoogleService,
    private readonly authService: AuthService,
    private readonly envService: EnvService,
  ) {}

  @SerializeOptions({
    groups: ['me'],
  })
  @Post('/')
  @ApiCreatedResponse({
    type: AuthEntity,
    status: HttpStatus.CREATED,
  })
  @ApiBadRequestResponse({
    status: HttpStatus.BAD_REQUEST,
    type: ResponseErrorDto,
  })
  async login(
    @Res({ passthrough: true }) res: Response,
    @Body() loginDto: AuthGoogleLoginDto,
  ) {
    const socialData = await this.authGoogleService.verify(loginDto.idToken);
    const { refreshToken, token, tokenExpires, user } =
      await this.authService.validateGoogleLogin(socialData);

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
}

import { EnvService } from './../../env/env.service';
import { Strategy } from 'passport-jwt';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { OrNeverType } from '../../utils/types/or-never.type';
import { JwtPayloadType } from './types/jwt-payload.type';
import { Request } from 'express';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(configService: EnvService) {
    super({
      jwtFromRequest: JwtStrategy.extractJwtFromRequest,
      secretOrKey: configService.get('JWT_SECRET'),
    });
  }

  private static extractJwtFromRequest(request: Request) {
    if (request.cookies && request.cookies.access_token) {
      return request.cookies.access_token;
    }
    return null;
  }

  public validate(payload: JwtPayloadType): OrNeverType<JwtPayloadType> {
    if (!payload.id) {
      throw new UnauthorizedException();
    }

    return payload;
  }
}

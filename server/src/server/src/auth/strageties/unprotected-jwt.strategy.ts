import { EnvService } from './../../env/env.service';
import { Strategy } from 'passport-jwt';
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { OrNeverType } from '../../utils/types/or-never.type';
import { JwtPayloadType } from './types/jwt-payload.type';
import { Request } from 'express';

@Injectable()
export class UnprotectedJwtStrategy extends PassportStrategy(
  Strategy,
  'unprotected-jwt',
) {
  constructor(configService: EnvService) {
    super({
      jwtFromRequest: UnprotectedJwtStrategy.extractJwtFromRequest,
      secretOrKey: configService.get('JWT_SECRET'),
      passReqToCallback: true,
    });
  }

  private static extractJwtFromRequest(request: Request) {
    if (request.cookies && request.cookies.access_token) {
      return request.cookies.access_token;
    }
    return null;
  }

  public validate(
    request: Request,
    payload: JwtPayloadType,
  ): OrNeverType<JwtPayloadType> {
    return payload || null; // Return null if payload is undefined
  }

  // Override handleRequest method
  handleRequest(err, user, info: any) {
    if (err || info instanceof Error) {
      throw err || info;
    }
    return user;
  }
}

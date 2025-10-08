import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { UsersModule } from 'src/users/users.module';
import { JwtStrategy } from './strageties/jwt.strategy';
import { EnvModule } from 'src/env/env.module';
import { SessionModule } from 'src/session/session.module';
import { MailModule } from 'src/mail/mail.module';
import { VerificationRepository } from './verification.repository';
import { UnprotectedJwtStrategy } from './strageties/unprotected-jwt.strategy';

@Module({
  imports: [
    PassportModule,
    JwtModule.register({}),
    UsersModule,
    EnvModule,
    SessionModule,
    MailModule,
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    JwtStrategy,
    VerificationRepository,
    UnprotectedJwtStrategy,
  ],
  exports: [AuthService],
})
export class AuthModule {}

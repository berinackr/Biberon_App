import { Module } from '@nestjs/common';
import { AuthGoogleService } from './auth-google.service';
import { AuthGoogleController } from './auth-google.controller';
import { EnvModule } from 'src/env/env.module';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  controllers: [AuthGoogleController],
  providers: [AuthGoogleService],
  imports: [EnvModule, AuthModule],
})
export class AuthGoogleModule {}

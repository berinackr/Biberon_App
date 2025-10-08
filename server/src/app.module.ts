import { Logger, Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { EnvModule } from './env/env.module';
import { envSchema } from './env/env';
import { ConfigModule } from '@nestjs/config';
import { LoggerModule } from './logging/logger.module';
import { ContextModule } from './context/context.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { SessionModule } from './session/session.module';
import { AuthGoogleModule } from './auth-google/auth-google.module';
import { DatabaseModule } from './database/database.module';
import { S3Module } from './s3/s3.module';
import { ThrottlerModule } from '@nestjs/throttler';
import { ForumModule } from './forum/forum.module';

@Module({
  imports: [
    EnvModule,
    ConfigModule.forRoot({
      validate: (env) => envSchema.parse(env),
      isGlobal: true,
    }),
    DatabaseModule,
    LoggerModule,
    ContextModule,
    AuthModule,
    UsersModule,
    SessionModule,
    AuthGoogleModule,
    S3Module,
    ThrottlerModule.forRoot({
      throttlers: [
        {
          limit: 3,
          ttl: 60000 * 60,
        },
      ],
    }),
    ForumModule,
  ],
  controllers: [AppController],
  providers: [AppService, Logger],
})
export class AppModule {}

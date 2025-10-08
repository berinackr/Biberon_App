import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { MailModule } from '../mail/mail.module';
import { BabyService } from './baby.service';
import { PregnancyService } from './pregnancy.service';
import { S3Module } from '../s3/s3.module';
import { UsersRepository } from './users.repository';
import { BabyRepository } from './baby.repository';
import { PregnancyRepository } from './pregnancy.repository';

@Module({
  imports: [MailModule, S3Module],
  controllers: [UsersController],
  providers: [
    UsersService,
    BabyService,
    PregnancyService,
    UsersRepository,
    BabyRepository,
    PregnancyRepository,
  ],
  exports: [UsersService],
})
export class UsersModule {}

import { Module } from '@nestjs/common';
import { MailService } from './mail.service';
import { MailerModule } from '../mailer/mailer.module';
import { EnvModule } from 'src/env/env.module';

@Module({
  imports: [EnvModule, MailerModule],
  providers: [MailService],
  exports: [MailService],
})
export class MailModule {}

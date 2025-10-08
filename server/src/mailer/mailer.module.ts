import { Module } from '@nestjs/common';
import { MailerService } from './mailer.service';
import { EnvModule } from 'src/env/env.module';

@Module({
  providers: [MailerService],
  exports: [MailerService],
  imports: [EnvModule],
})
export class MailerModule {}

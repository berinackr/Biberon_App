import { Inject, Injectable } from '@nestjs/common';

import { MailData } from './interfaces/mail-data.interface';
import { MailerService } from '../mailer/mailer.service';
import Logger, { LoggerKey } from '../logging/types/logger.type';
import ConfirmEmail from '../../emails/confirmation';
import ForgotPassword from '../../emails/forgot-password';
import { EnvService } from '../env/env.service';

@Injectable()
export class MailService {
  constructor(
    private readonly mailerService: MailerService,
    @Inject(LoggerKey) private logger: Logger,
    private envService: EnvService,
  ) {}

  async userSignUp(
    mailData: MailData<{ name: string; validationCode: string }>,
  ): Promise<void> {
    this.logger.debug(
      `Sending user sign up email to ${mailData.to} with name: ${mailData.data.name}`,
    );
    await this.mailerService.sendMail({
      to: mailData.to,
      subject: 'Biberon Uygulaması - Hesabınızı doğrulayın',
      template: ConfirmEmail({
        name: mailData.data.name,
        validationCode: mailData.data.validationCode,
      }),
    });
  }

  async forgotPassword(
    mailData: MailData<{ name: string; token: string }>,
  ): Promise<void> {
    this.logger.debug(
      `Sending forgot password email to ${mailData.to} with name: ${mailData.data.name}`,
    );
    await this.mailerService.sendMail({
      to: mailData.to,
      subject: 'Biberon Uygulaması - Şifre Sıfırlama',
      template: ForgotPassword({
        name: mailData.data.name,
        resetPasswordLink: `${this.envService.get('APP_URL')}/auth/reset?token=${mailData.data.token}`,
      }),
    });
  }
}

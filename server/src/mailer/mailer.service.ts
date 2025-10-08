import { Inject, Injectable } from '@nestjs/common';
import nodemailer from 'nodemailer';
import * as aws from '@aws-sdk/client-ses';
import { render } from '@react-email/render';
import { EnvService } from '../env/env.service';
import Logger, { LoggerKey } from '../logging/types/logger.type';
@Injectable()
export class MailerService {
  private readonly transporter: nodemailer.Transporter;
  private readonly sesService: aws.SES;
  constructor(
    private envService: EnvService,
    @Inject(LoggerKey) private logger: Logger,
  ) {
    this.sesService = new aws.SES({
      apiVersion: '2010-12-01',
      // stockholm region
      region: 'eu-north-1',
      credentials: {
        accessKeyId: this.envService.get('AWS_SES_ACCESS_KEY') ?? '',
        secretAccessKey: this.envService.get('AWS_SES_SECRET_ACCESS_KEY') ?? '',
      },
    });
    this.transporter =
      this.envService.get('NODE_ENV') === 'development' ||
      this.envService.get('AWS_SES_ACCESS_KEY') === undefined
        ? nodemailer.createTransport({
            host: this.envService.get('MAIL_HOST'),
            port: this.envService.get('MAIL_PORT'),
            ignoreTLS: this.envService.get('MAIL_IGNORE_TLS'),
            secure: this.envService.get('MAIL_SECURE'),
            requireTLS: true,
          })
        : nodemailer.createTransport({
            SES: { ses: this.sesService, aws },
          });
  }

  async sendMail({
    template,
    ...mailOptions
  }: nodemailer.SendMailOptions & {
    template: any;
  }): Promise<void> {
    this.logger.info(
      `Sending email with ${this.envService.get('NODE_ENV') === 'development' ? 'SMTP' : 'AWS SES'}`,
    );
    const html = render(template);

    await this.transporter.sendMail({
      ...mailOptions,
      from: mailOptions.from
        ? mailOptions.from
        : this.envService.get('MAIL_DEFAULT_EMAIL'),
      html,
    });
  }
}

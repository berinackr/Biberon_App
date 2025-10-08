import {
  Inject,
  Injectable,
  UnprocessableEntityException,
} from '@nestjs/common';
import { OAuth2Client } from 'google-auth-library';
import { EnvService } from '../env/env.service';
import Logger, { LoggerKey } from '../logging/types/logger.type';

@Injectable()
export class AuthGoogleService {
  private google: OAuth2Client;

  constructor(
    private envService: EnvService,
    @Inject(LoggerKey) private logger: Logger,
  ) {
    this.google = new OAuth2Client({
      clientId: this.envService.get('GOOGLE_CLIENT_ID'),
      clientSecret: this.envService.get('GOOGLE_CLIENT_SECRET'),
    });
  }

  async verify(token: string) {
    this.logger.debug('Verifying Google token');
    const ticket = await this.google.verifyIdToken({
      idToken: token,
      audience: this.envService.get('GOOGLE_CLIENT_ID'),
    });

    const data = ticket.getPayload();

    if (!data) {
      this.logger.error('Invalid token');
      throw new UnprocessableEntityException('Geçersiz ID');
    }

    return {
      id: data.sub,
      email: data.email,
      name: data.name,
      picture: data.picture,
    };
  }
}

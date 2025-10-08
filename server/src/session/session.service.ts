import { Inject, Injectable } from '@nestjs/common';
import Logger, { LoggerKey } from '../logging/types/logger.type';
import { SessionRepository } from './session.repository';

@Injectable()
export class SessionService {
  constructor(
    private readonly sessionRepository: SessionRepository,
    @Inject(LoggerKey) private logger: Logger,
  ) {}

  async createSession({
    userId,
    token,
    expiresAt,
  }: {
    userId: string;
    token: string;
    expiresAt: Date;
  }) {
    this.logger.info('Creating session for user', {
      props: {
        userId,
        expiresAt,
      },
    });
    return this.sessionRepository.createSession({
      userId,
      token,
      expiresAt,
    });
  }

  async getSession(token: string) {
    return this.sessionRepository.getSession(token);
  }

  async updateSession({
    id,
    token,
    expiresAt,
  }: {
    id: string;
    token: string;
    expiresAt: Date;
  }) {
    this.logger.info('Updating session', {
      props: {
        id,
        expiresAt,
      },
    });
    return this.sessionRepository.updateSession({
      id,
      token,
      expiresAt,
    });
  }

  async deleteSession(token: string) {
    return this.sessionRepository.deleteSession(token);
  }
}

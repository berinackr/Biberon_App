import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from 'src/users/users.service';
import { SessionService } from 'src/session/session.service';
import { MailService } from 'src/mail/mail.service';
import { LoggerKey } from 'src/logging/types/logger.type';
import { EnvService } from 'src/env/env.service';
import { MailerService } from 'src/mailer/mailer.service';
import { ConfigService } from '@nestjs/config';
import { S3Service } from '../s3/s3.service';
import { VerificationRepository } from './verification.repository';
import { UsersRepository } from '../users/users.repository';
import { SessionRepository } from '../session/session.repository';

jest.mock('../../emails/confirmation', () => {
  return jest.fn().mockImplementation(() => {
    return {
      send: jest.fn(),
      // add other methods as needed
    };
  });
});

jest.mock('../../emails/forgot-password', () => {
  return jest.fn().mockImplementation(() => {
    return {
      send: jest.fn(),
      // add other methods as needed
    };
  });
});

describe('AuthController', () => {
  let controller: AuthController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        AuthService,
        AuthService,
        JwtService,
        UsersService,
        SessionService,
        MailService,
        EnvService,

        MailerService,
        ConfigService,
        S3Service,
        {
          provide: LoggerKey,
          useValue: {
            log: jest.fn(),
            error: jest.fn(),
            warn: jest.fn(),
            debug: jest.fn(),
            verbose: jest.fn(),
            startProfile: jest.fn(),
            info: jest.fn(),
            fatal: jest.fn(),
            emergency: jest.fn(),
            // add other methods as needed
          },
        },
        {
          provide: VerificationRepository,
          useValue: {}, // Provide a mock Database instance here
        },
        {
          provide: UsersRepository,
          useValue: {}, // Provide a mock Database instance here
        },
        {
          provide: SessionRepository,
          useValue: {}, // Provide a mock Database instance here
        },
      ],
    }).compile();

    controller = module.get<AuthController>(AuthController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});

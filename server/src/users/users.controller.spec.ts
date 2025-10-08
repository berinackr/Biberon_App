import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { LoggerKey } from '../logging/types/logger.type';
import { MailService } from '../mail/mail.service';
import { MailerService } from '../mailer/mailer.service';
import { EnvService } from '../env/env.service';
import { ConfigService } from '@nestjs/config';
import { BabyService } from './baby.service';
import { PregnancyService } from './pregnancy.service';
import { S3Service } from '../s3/s3.service';
import { ThrottlerModule } from '@nestjs/throttler';
import { UsersRepository } from './users.repository';
import { PregnancyRepository } from './pregnancy.repository';
import { BabyRepository } from './baby.repository';

jest.mock('../../emails/forgot-password', () => {
  return jest.fn().mockImplementation(() => {
    return {
      send: jest.fn(),
      // add other methods as needed
    };
  });
});

jest.mock('../../emails/confirmation', () => {
  return jest.fn().mockImplementation(() => {
    return {
      send: jest.fn(),
      // add other methods as needed
    };
  });
});

describe('UsersController', () => {
  let controller: UsersController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UsersController],
      imports: [
        ThrottlerModule.forRoot({
          throttlers: [
            {
              limit: 3,
              ttl: 60000 * 60,
            },
          ],
        }),
      ],
      providers: [
        UsersService,
        MailService,
        MailerService,
        EnvService,
        ConfigService,
        BabyService,
        PregnancyService,
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
          provide: UsersRepository,
          useValue: {}, // Provide a mock Database instance here
        },
        {
          provide: PregnancyRepository,
          useValue: {}, // Provide a mock Database instance here
        },
        {
          provide: BabyRepository,
          useValue: {}, // Provide a mock Database instance here
        },
      ],
    }).compile();

    controller = module.get<UsersController>(UsersController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});

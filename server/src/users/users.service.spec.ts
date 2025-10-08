import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import Logger, { LoggerKey } from '../logging/types/logger.type';
import { MailService } from '../mail/mail.service';
import { MailerService } from '../mailer/mailer.service';
import { EnvService } from '../env/env.service';
import { ConfigService } from '@nestjs/config';
import { UserProfileEntity } from './entity/user-profile';
import { S3Service } from '../s3/s3.service';
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

describe('UsersService', () => {
  let service: UsersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        MailService,
        MailerService,
        EnvService,
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
          provide: UsersRepository,
          useValue: {
            updateUserProfile: jest.fn().mockResolvedValue({}),
          }, // Provide a mock Database instance here
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

    service = module.get<UsersService>(UsersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('updateUserProfile', () => {
    let mockLogger: jest.Mocked<Logger>;

    beforeEach(() => {
      mockLogger = {
        debug: jest.fn(),
        info: jest.fn(),
        // add other methods as needed
      } as any;
      service['logger'] = mockLogger;
    });

    // Add more tests for other exceptions and conditions

    it('should update user profile successfully', async () => {
      const mockProfile = {
        dateOfBirth: new Date(),
        name: null,
        cityId: 1,
        bio: 'bio',
      };

      const result = await service.updateUserProfile(mockProfile, 'user1');

      expect(result).toBeInstanceOf(UserProfileEntity);
    });
  });
});

import { Test, TestingModule } from '@nestjs/testing';
import { AuthGoogleService } from './auth-google.service';
import { EnvService } from '../env/env.service';
import { LoggerKey } from 'src/logging/types/logger.type';

describe('AuthGoogleService', () => {
  let service: AuthGoogleService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthGoogleService,
        {
          provide: EnvService,
          useValue: {
            get: jest.fn().mockImplementation((key: string) => key),
          },
        },
        {
          provide: LoggerKey,
          useValue: {
            log: jest.fn(),
            error: jest.fn(),
            warn: jest.fn(),
            debug: jest.fn(),
            verbose: jest.fn(),
            // add other methods as needed
          },
        },
      ],
    }).compile();

    service = module.get<AuthGoogleService>(AuthGoogleService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});

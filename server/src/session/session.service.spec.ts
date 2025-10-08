import { Test, TestingModule } from '@nestjs/testing';
import { SessionService } from './session.service';
import { LoggerKey } from '../logging/types/logger.type';
import { SessionRepository } from './session.repository';

describe('SessionService', () => {
  let service: SessionService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SessionService,
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
          provide: SessionRepository,
          useValue: {}, // Provide a mock Database instance here
        },
      ],
    }).compile();

    service = module.get<SessionService>(SessionService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});

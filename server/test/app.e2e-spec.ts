import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from './../src/app.module';

jest.mock('../emails/confirmation', () => {
  return jest.fn().mockImplementation(() => {
    return {
      send: jest.fn(),
      // add other methods as needed
    };
  });
});

jest.mock('../emails/forgot-password', () => {
  return jest.fn().mockImplementation(() => {
    return {
      send: jest.fn(),
      // add other methods as needed
    };
  });
});

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/ (GET)', () => {
    return request(app.getHttpServer())
      .get('/')
      .expect(200)
      .expect('Hello World!');
  });
});

import request from 'supertest';
import { Test } from '@nestjs/testing';
import {
  BadRequestException,
  ClassSerializerInterceptor,
  INestApplication,
  ValidationPipe,
  VersioningType,
} from '@nestjs/common';
import { AppModule } from '../src/app.module';
// import * as bcrypt from 'bcrypt';
import cookieParser from 'cookie-parser';
import { UpdateUserProfileDto } from '../src/users/dto/update-user-profile.dto';
import NestjsLoggerServiceAdapter from '../src/logging/logger-service';
import { getErrorConstraintsRecursion } from '../src/utils/beautify-validation-errors';
import { Reflector } from '@nestjs/core';
import { DatabaseModule } from '../src/database/database.module';
import { DatabaseService } from '../src/database/database.service';

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

describe('/users/profile', () => {
  let app: INestApplication;
  let dbService: DatabaseService;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule, DatabaseModule],
    }).compile();

    app = moduleRef.createNestApplication();
    app.use(cookieParser());
    app.useLogger(app.get(NestjsLoggerServiceAdapter));
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        stopAtFirstError: true,
        exceptionFactory: (validationErrors) => {
          return new BadRequestException(
            // return string not array error message on turkish language
            validationErrors
              .map((error) => {
                return getErrorConstraintsRecursion(error);
              })
              .join('\n'),
          );
        },
      }),
    );
    dbService = moduleRef.get<DatabaseService>(DatabaseService);
    app.useGlobalInterceptors(
      new ClassSerializerInterceptor(app.get(Reflector)),
    );

    app.enableVersioning({
      type: VersioningType.URI,
    });

    await app.init();
  });

  beforeEach(async () => {});

  it('should return 201 when user profile created', async () => {
    const response = await request(app.getHttpServer())
      .post('/v1/auth/email')
      .send({
        email: 'biberonapp@gmail.com',
        password: 'password',
      });

    const accessToken = response.body.token;

    const profile: UpdateUserProfileDto = {
      cityId: 1,
      bio: null,
      dateOfBirth: new Date(
        new Date().setFullYear(new Date().getFullYear() - 20),
      ),
      name: null,
    };

    const response2 = await request(app.getHttpServer())
      .put('/v1/users/profile')
      .set('Cookie', `access_token=${accessToken}`)
      .send(profile);

    expect(response2.status).toBe(200);
    expect(response2.body).toHaveProperty('userId');
    expect(response2.body.cityId).toBe(profile.cityId);

    const response3 = await request(app.getHttpServer())
      .get('/v1/users/profile')
      .set('Cookie', `access_token=${accessToken}`);

    expect(response3.status).toBe(200);
  });

  afterAll(async () => {
    await app.close();
    await dbService.onModuleDestroy();
  });
});

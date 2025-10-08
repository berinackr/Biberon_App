import { NestFactory, Reflector } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { EnvService } from './env/env.service';
import {
  BadRequestException,
  ClassSerializerInterceptor,
  Logger,
  VersioningType,
} from '@nestjs/common';
import NestjsLoggerServiceAdapter from './logging/logger-service';
import { ValidationPipe } from '@nestjs/common';
import cookieParser from 'cookie-parser';
import { getErrorConstraintsRecursion } from './utils/beautify-validation-errors';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    bufferLogs: true,
  });

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
  app.useGlobalInterceptors(new ClassSerializerInterceptor(app.get(Reflector)));
  app.use(cookieParser());
  app.enableShutdownHooks();
  app.enableVersioning({
    type: VersioningType.URI,
  });

  const config = new DocumentBuilder()
    .setTitle('Biberon API')
    .setDescription('Biberon API description')
    .setVersion('0.1')
    .addCookieAuth('access_token', {
      type: 'http',
      in: 'Header',
      scheme: 'bearer',
    })
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const configService = app.get(EnvService);
  const env = configService.get('NODE_ENV');
  if (env === 'development') {
    app.enableCors({
      origin: 'http://localhost:4000',
      methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
      credentials: true,
    });
  }
  const port = configService.get('PORT');
  Logger.log(`Server running on... http://localhost:${port}`, 'Bootstrap');
  await app.listen(port);
}
void bootstrap();

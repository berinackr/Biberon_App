import {
  Global,
  Inject,
  MiddlewareConsumer,
  Module,
  NestModule,
} from '@nestjs/common';

import morgan from 'morgan';
import Logger, { LoggerBaseKey, LoggerKey } from './types/logger.type';
import WinstonLogger, {
  WinstonLoggerTransportsKey,
} from './winston/winston-logger';
import LoggerService from './logger';
import NestjsLoggerServiceAdapter from './logger-service';
import ConsoleTransport from './winston/transports/console-transport';
import FileTransport from './winston/transports/file-transport';
import LokiTransport from 'winston-loki';
import winston from 'winston';
import { EnvModule } from '../env/env.module';
import { EnvService } from '../env/env.service';

@Global()
@Module({
  imports: [EnvModule],
  controllers: [],
  providers: [
    {
      provide: LoggerBaseKey,
      useClass: WinstonLogger,
    },
    {
      provide: LoggerKey,
      useClass: LoggerService,
    },
    {
      provide: NestjsLoggerServiceAdapter,
      useFactory: (logger: Logger) => new NestjsLoggerServiceAdapter(logger),
      inject: [LoggerKey],
    },

    {
      provide: WinstonLoggerTransportsKey,
      useFactory: (envService: EnvService) => {
        const transports = <ConsoleTransport[]>[];

        transports.push(ConsoleTransport.createColorize());

        transports.push(FileTransport.create());

        if (envService.get('NODE_ENV') === 'production') {
          transports.push(
            new LokiTransport({
              host: envService.get('LOKI_URL')!,
              basicAuth:
                envService.get('LOKI_USERNAME') +
                ':' +
                envService.get('LOKI_PASSWORD'),
              json: true,
              labels: {
                app: envService.get('APP_NAME'),
              },
              format: winston.format.json(),
              replaceTimestamp: true,
              onConnectionError(error) {
                console.error('Error connecting to Loki:', error);
              },
            }),
          );
        }

        return transports;
      },
      inject: [EnvService],
    },
  ],
  exports: [LoggerKey, NestjsLoggerServiceAdapter],
})
export class LoggerModule implements NestModule {
  public constructor(@Inject(LoggerKey) private logger: Logger) {}

  public configure(consumer: MiddlewareConsumer): void {
    consumer
      .apply(
        morgan('dev', {
          stream: {
            write: (message: string) => {
              this.logger.debug(message, {
                sourceClass: 'RequestLogger',
              });
            },
          },
        }),
      )
      .forRoutes('*');
  }
}

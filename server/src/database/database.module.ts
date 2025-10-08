import { Module } from '@nestjs/common';
import { KyselyModule } from 'nestjs-kysely';
import {
  CamelCasePlugin,
  ParseJSONResultsPlugin,
  PostgresDialect,
} from 'kysely';
import { Pool } from 'pg';
import { EnvModule } from '../env/env.module';
import { EnvService } from '../env/env.service';
import Logger, { LoggerKey } from '../logging/types/logger.type';
import { LoggerModule } from '../logging/logger.module';
import { DatabaseService } from './database.service';

@Module({
  providers: [DatabaseService],
  imports: [
    EnvModule,
    LoggerModule,
    KyselyModule.forRootAsync({
      inject: [EnvService, LoggerKey],
      useFactory: (configService: EnvService, logger: Logger) => ({
        dialect: new PostgresDialect({
          pool: new Pool({
            connectionString: `postgresql://${configService.get('DATABASE_USERNAME')}:${configService.get('DATABASE_PASSWORD')}@${configService.get('DATABASE_HOST')}:5432/${configService.get('DATABASE_NAME')}?schema=public`,
          }),
        }),
        log: (event) => {
          logger.debug(event.query.sql, {
            props: {
              duration: event.queryDurationMillis.toFixed(2),
              level: event.level,
            },
            sourceClass: 'QueryLogger',
          });
        },
        plugins: [new CamelCasePlugin(), new ParseJSONResultsPlugin()],
      }),
    }),
  ],
})
export class DatabaseModule {}

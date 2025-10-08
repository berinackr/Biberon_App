import { Inject, Injectable } from '@nestjs/common';
import Logger, { LoggerKey } from './logging/types/logger.type';

@Injectable()
export class AppService {
  constructor(@Inject(LoggerKey) private logger: Logger) {}
  async getHello() {
    this.logger.startProfile('getHello');

    // Await random time
    await new Promise((resolve) =>
      setTimeout(resolve, Math.floor(Math.random() * 1000)),
    );

    // Debug
    this.logger.debug('I am a debug message!');

    // Info
    this.logger.info('I am an info message!');

    // Warn
    this.logger.warn('I am a warn message!');

    // Error
    this.logger.error('I am an error message!');

    // Fatal
    this.logger.fatal('I am a fatal message!');

    // Emergency
    this.logger.emergency('I am an emergency message!');

    return 'Hello World!';
  }
}

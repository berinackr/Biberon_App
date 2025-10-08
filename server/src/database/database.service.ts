import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { Kysely } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';

@Injectable()
export class DatabaseService implements OnModuleDestroy {
  constructor(@InjectKysely() private readonly db: Kysely<any>) {}

  async onModuleDestroy() {
    await this.db.destroy();
  }
}

import { Injectable } from '@nestjs/common';
import { Database } from '../database/database';
import { InjectKysely } from 'nestjs-kysely';
import ms from 'ms';

@Injectable()
export class VerificationRepository {
  constructor(@InjectKysely() private readonly db: Database) {}

  async upsertVerificationRequest(userId: string, code: string) {
    return await this.db
      .insertInto('verificationRequest')
      .values({
        userId,
        code,
        expires: new Date(Date.now() + ms('1h')),
      })
      .returningAll()
      .onConflict((oc) =>
        oc.column('userId').doUpdateSet((eb) => ({
          code,
          expires: new Date(Date.now() + ms('1h')),
          retry: eb('verificationRequest.retry', '+', 1),
        })),
      )
      .executeTakeFirst();
  }

  async approveVerificationRequest(userId: string) {
    return await this.db
      .updateTable('verificationRequest')
      .set({
        status: 'APPROVED',
        expires: new Date(),
      })
      .where('userId', '=', userId)
      .execute();
  }

  async getVerificationRequest(userId: string) {
    return await this.db
      .selectFrom('verificationRequest')
      .selectAll()
      .where('userId', '=', userId)
      .executeTakeFirst();
  }
}

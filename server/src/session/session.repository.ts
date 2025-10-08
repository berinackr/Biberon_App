import { Injectable } from '@nestjs/common';
import { InjectKysely } from 'nestjs-kysely';
import { Database } from '../database/database';

@Injectable()
export class SessionRepository {
  constructor(@InjectKysely() private readonly db: Database) {}

  async createSession({
    userId,
    token,
    expiresAt,
  }: {
    userId: string;
    token: string;
    expiresAt: Date;
  }) {
    return await this.db
      .insertInto('session')
      .values({
        userId,
        token,
        expiresAt,
        lastActivity: new Date(),
      })
      .returningAll()
      .executeTakeFirstOrThrow();
  }

  async getSession(token: string) {
    return await this.db
      .selectFrom('session')
      .selectAll()
      .where('token', '=', token)
      .executeTakeFirst();
  }

  async updateSession({
    id,
    token,
    expiresAt,
  }: {
    id: string;
    token: string;
    expiresAt: Date;
  }) {
    return await this.db
      .updateTable('session')
      .set({
        token,
        expiresAt,
        lastActivity: new Date(),
      })
      .where('id', '=', id)
      .returningAll()
      .executeTakeFirstOrThrow();
  }

  async deleteSession(token: string) {
    return await this.db
      .deleteFrom('session')
      .where('token', '=', token)
      .execute();
  }
}

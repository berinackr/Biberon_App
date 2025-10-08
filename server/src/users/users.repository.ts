import { Injectable } from '@nestjs/common';
import { InjectKysely } from 'nestjs-kysely';
import { Database } from '../database/database';
import { provider } from '../database/enums';
import { UpdateUserDto } from './dto/update-user.dto';
import { AuthEmailRegisterDto } from '../auth/dto/auth-email-register.dto';
import { jsonArrayFrom, jsonBuildObject } from 'kysely/helpers/postgres';
import { CreateSocialUserDto } from './dto/create-social-user.dto';
import { sql } from 'kysely';
import { UpdateUserProfileDto } from './dto/update-user-profile.dto';

@Injectable()
export class UsersRepository {
  constructor(@InjectKysely() private readonly db: Database) {}

  async getUserInfo(id: string) {
    return await this.db
      .selectFrom('user')
      .where('id', '=', id)
      .select([
        'id',
        'email',
        'username',
        'role',
        'emailVerified',
        'avatarPath',
      ])
      .executeTakeFirst();
  }

  async findByOneEmail(email: string) {
    const user = await this.db
      .selectFrom('user')
      .where('email', '=', email)
      .selectAll()
      .executeTakeFirst();

    return user ?? null;
  }

  async findOneBySocialId(socialId: string, provider: provider) {
    const user = await this.db
      .selectFrom('user')
      .where('socialId', '=', socialId)
      .where('provider', '=', provider)
      .selectAll()
      .executeTakeFirst();

    return user ?? null;
  }

  async userExistsByUsername(username: string, email?: string) {
    const query = this.db
      .selectFrom('user')
      .where((eb) =>
        email
          ? eb.or([eb('username', '=', username), eb('email', '=', email)])
          : eb('username', '=', username),
      )
      .selectAll();
    return await this.db
      .selectFrom('user')
      .select(({ exists }) => [exists(query).as('exists')])
      .executeTakeFirst();
  }

  async updateUser(user: UpdateUserDto & { id: string }) {
    return await this.db
      .updateTable('user')
      .set(user)
      .where('id', '=', user.id)
      .executeTakeFirst();
  }

  async createUser({ email, password, username }: AuthEmailRegisterDto) {
    return await this.db.transaction().execute(async (trx) => {
      const user = await trx
        .insertInto('user')
        .values({
          email,
          password,
          username,
          displayName: username,
          updatedAt: new Date(),
        })
        .returningAll()
        .executeTakeFirstOrThrow();

      await trx
        .insertInto('profile')
        .values({
          userId: user.id,
        })
        .executeTakeFirst();

      return user;
    });
  }

  async createSocialUser(data: CreateSocialUserDto) {
    return await this.db.transaction().execute(async (trx) => {
      const user = await trx
        .insertInto('user')
        .values({
          email: data.email,
          socialId: data.socialId,
          provider: data.provider,
          username: data.username,
          displayName: data.username,
          emailVerified: true,
          updatedAt: new Date(),
        })
        .returningAll()
        .executeTakeFirstOrThrow();

      await trx
        .insertInto('profile')
        .values({
          userId: user.id,
        })
        .executeTakeFirst();

      return user;
    });
  }

  async getUserWithPasswordResetData(email: string) {
    return await this.db
      .selectFrom('user')
      .leftJoin(
        'passwordResetRequest',
        'user.id',
        'passwordResetRequest.userId',
      )
      .select(({ ref, eb }) => [
        'user.email',
        'user.id',
        'user.username',
        eb
          .case()
          .when('passwordResetRequest.token', '!=', 'null')
          .then(
            jsonBuildObject({
              expires: ref('passwordResetRequest.expires').$notNull(),
              id: ref('passwordResetRequest.id').$notNull(),
              retry: ref('passwordResetRequest.retry').$notNull(),
              status: ref('passwordResetRequest.status').$notNull(),
            }),
          )
          .end()
          .as('passwordReset'),
      ])
      .where('user.email', '=', email)
      .executeTakeFirst();
  }

  async getUserPasswordResetDataWithToken(token: string) {
    return await this.db
      .selectFrom('passwordResetRequest')
      .selectAll()
      .where('token', '=', token)
      .executeTakeFirst();
  }

  async approvePasswordResetRequest(id: number) {
    return await this.db
      .updateTable('passwordResetRequest')
      .set({
        status: 'APPROVED',
      })
      .where('id', '=', id)
      .execute();
  }

  async upsertResetPassword(userId: string, token: string, expires: Date) {
    return await this.db
      .insertInto('passwordResetRequest')
      .values({
        userId,
        token,
        expires,
        retry: 0,
      })
      .onConflict((oc) =>
        oc.column('userId').doUpdateSet((eb) => ({
          token,
          expires,
          retry: eb('passwordResetRequest.retry', '+', 1),
        })),
      )
      .execute();
  }

  async getUserProfile(userId: string) {
    return await this.db
      .selectFrom('profile')
      .where('userId', '=', userId)
      .leftJoin('pregnancy', (join) =>
        join
          .onRef('profile.id', '=', 'pregnancy.profileId')
          .on('isActive', '=', true),
      )
      .leftJoin('baby', 'profile.id', 'baby.profileId')
      .leftJoin('fetus', 'pregnancy.id', 'fetus.pregnancyId')
      .select(({ eb, ref }) => [
        eb
          .case()
          .when('pregnancy.id', 'is not', null)
          .then(
            jsonBuildObject({
              birthGiven: ref('pregnancy.birthGiven').$notNull(),
              id: ref('pregnancy.id').$notNull(),
              dueDate: ref('pregnancy.dueDate').$notNull(),
              endDate: ref('pregnancy.endDate'),
              profileId: ref('pregnancy.profileId').$notNull(),
              lastPeriodDate: ref('pregnancy.lastPeriodDate'),
              notes: ref('pregnancy.notes'),
              type: ref('pregnancy.type').$notNull(),
              isActive: ref('pregnancy.isActive').$notNull(),
              deliveryType: ref('pregnancy.deliveryType'),
              fetus: jsonArrayFrom(
                jsonBuildObject({
                  id: ref('fetus.id').$notNull(),
                  gender: ref('fetus.gender').$notNull(),
                }),
              ),
            }),
          )
          .end()
          .as('pregnancy'),
        eb.fn
          .coalesce(
            eb.fn
              .jsonAgg(
                jsonBuildObject({
                  birthHeight: ref('baby.birthHeight'),
                  birthWeight: ref('baby.birthWeight'),
                  dateOfBirth: ref('baby.dateOfBirth').$notNull(),
                  notes: ref('baby.notes'),
                  id: ref('baby.id').$notNull(),
                  profileId: ref('baby.profileId').$notNull(),
                  gender: ref('baby.gender').$notNull(),
                  birthTime: ref('baby.birthTime'),
                  name: ref('baby.name').$notNull(),
                  createdAt: ref('baby.createdAt').$notNull(),
                  updatedAt: ref('baby.updatedAt').$notNull(),
                }),
              )
              .filterWhere('baby.id', 'is not', null),
            sql`'[]'`,
          )
          .as('babies'),
      ])
      .groupBy(['pregnancy.id', 'profile.id', 'fetus.id'])
      .selectAll('profile')
      .executeTakeFirst();
  }

  async updateUserProfile(userId: string, data: UpdateUserProfileDto) {
    return await this.db
      .updateTable('profile')
      .set(data)
      .where('userId', '=', userId)
      .returningAll()
      .executeTakeFirst();
  }

  async getUserAvatarUpdateAt(userId: string) {
    return await this.db
      .selectFrom('user')
      .where('id', '=', userId)
      .select('avatarUpdatedAt')
      .executeTakeFirst();
  }

  async getUserAvatarInfo(userId: string) {
    return await this.db
      .selectFrom('user')
      .where('id', '=', userId)
      .select(['avatarPath', 'avatarUpdatedAt', 'avatarUploadRequestedAt'])
      .executeTakeFirst();
  }
}

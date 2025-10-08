import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectKysely } from 'nestjs-kysely';
import { Database } from '../database/database';
import { jsonArrayFrom, jsonBuildObject } from 'kysely/helpers/postgres';
import { CreatePregnancyInput } from './types/create-pregnancy.type';
import { SelectQueryBuilder, expressionBuilder } from 'kysely';
import { DB } from '../database/types';
import { deliveryType, gender, pregnancyType } from '../database/enums';

@Injectable()
export class PregnancyRepository {
  constructor(@InjectKysely() private readonly db: Database) {}

  async getPregnancy(
    userId: string,
    pregnancyId: number,
    includeFetuses: boolean,
  ) {
    return await this.db
      .selectFrom('pregnancy')
      .innerJoin('profile', 'profile.id', 'pregnancy.profileId')
      .$if(includeFetuses, (qb) =>
        qb
          .innerJoin('fetus', 'fetus.pregnancyId', 'pregnancy.id')
          .select(({ eb, ref }) => [
            eb.fn
              .jsonAgg(
                jsonBuildObject({
                  id: ref('fetus.id'),
                  gender: ref('fetus.gender'),
                  pregnancyId: ref('fetus.pregnancyId'),
                }),
              )
              .as('fetuses'),
          ]),
      )
      .where('profile.userId', '=', userId)
      .where('pregnancy.id', '=', pregnancyId)
      .selectAll('pregnancy')
      .groupBy('pregnancy.id')
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Böyle bir hamilelik bulunamadı.'),
      );
  }

  async getActivePregnancy(userId: string, includeFetuses: boolean) {
    return await this.db
      .selectFrom('pregnancy')
      .innerJoin('profile', 'profile.id', 'pregnancy.profileId')
      .$if(includeFetuses, (qb) =>
        qb
          .innerJoin('fetus', 'fetus.pregnancyId', 'pregnancy.id')
          .select(({ eb, ref }) => [
            eb.fn
              .jsonAgg(
                jsonBuildObject({
                  id: ref('fetus.id'),
                  gender: ref('fetus.gender'),
                  pregnancyId: ref('fetus.pregnancyId'),
                }),
              )
              .as('fetuses'),
          ]),
      )
      .where('profile.userId', '=', userId)
      .where('pregnancy.isActive', '=', true)
      .selectAll('pregnancy')
      .groupBy('pregnancy.id')
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Böyle bir hamilelik bulunamadı.'),
      );
  }

  async deletePregnancy(userId: string, pregnancyId: number) {
    return await this.db.transaction().execute(async (trx) => {
      const data = await trx
        .selectFrom('pregnancy')
        .innerJoin('profile', 'profile.id', 'pregnancy.profileId')
        .select(['profile.userId', 'profile.id'])
        .where('pregnancy.id', '=', pregnancyId)
        .executeTakeFirstOrThrow(
          () => new NotFoundException('Böyle bir hamilelik bulunamadı.'),
        );

      if (data.userId !== userId) {
        throw new NotFoundException('Böyle bir hamilelik bulunamadı.');
      }

      await trx.deleteFrom('pregnancy').where('id', '=', pregnancyId).execute();

      await trx
        .updateTable('profile')
        .where('id', '=', data.id)
        .set((eb) => ({
          isPregnant: eb
            .case()
            .when(
              eb.exists(
                eb
                  .selectFrom('pregnancy')
                  .where('pregnancy.profileId', '=', data.id)
                  .where('isActive', '=', true),
              ),
            )
            .then(true)
            .else(false)
            .end(),
        }))
        .execute();
    });
  }

  async setFetusGender(userId: string, fetusId: number, gender: gender) {
    return await this.db
      .updateTable('fetus')
      .from('profile')
      .where('fetus.id', '=', fetusId)
      .where('pregnancyId', 'in', (qb) =>
        qb
          .selectFrom('pregnancy')
          .select('pregnancy.id')
          .innerJoin('profile', 'profile.id', 'pregnancy.profileId')
          .whereRef('pregnancy.id', '=', 'fetus.pregnancyId')
          .where('profile.userId', '=', userId),
      )
      .set({
        gender,
      })
      .returning('fetus.id')
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Böyle bir fetus bulunamadı.'),
      );
  }

  async setPregnancyUnactive(userId: string, birthDate: Date) {
    return await this.db
      .with('updateProfile', (db) =>
        db
          .updateTable('profile')
          .set({ isPregnant: false })
          .where('userId', '=', userId),
      )
      .updateTable('pregnancy')
      .set({
        isActive: false,
        birthGiven: true,
        dueDate: birthDate,
        endDate: birthDate,
      })
      .where('isActive', '=', true)
      .where('pregnancy.profileId', 'in', (qb) =>
        qb.selectFrom('profile').select('id').where('userId', '=', userId),
      )
      .returningAll()
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Aktif bir hamilelik bulunamadı.'),
      );
  }

  async createPregnancy(
    userId: string,
    { fetuses, ...data }: CreatePregnancyInput,
  ) {
    return await this.db.transaction().execute(async (trx) => {
      const profile = await trx
        .selectFrom('profile')
        .leftJoin('pregnancy', (join) =>
          join
            .onRef('profile.id', '=', 'pregnancy.profileId')
            .on('isActive', '=', true),
        )
        .select([
          'profile.id',
          'profile.isPregnant',
          'pregnancy.id as activePregnancyId',
        ])
        .where('userId', '=', userId)
        .executeTakeFirstOrThrow(
          () => new NotFoundException('Böyle bir kullanıcı bulunamadı.'),
        );

      const pregnancy = await trx
        .insertInto('pregnancy')
        .values({
          ...data,
          profileId: profile.id,
        })
        .returningAll()
        .executeTakeFirstOrThrow();

      const fetusData = await trx
        .insertInto('fetus')
        .values(
          fetuses.map((fetus) => ({ ...fetus, pregnancyId: pregnancy.id })),
        )
        .returningAll()
        .execute();

      if (!profile.isPregnant && !data.birthGiven) {
        await trx
          .updateTable('profile')
          .set({ isPregnant: true })
          .where('id', '=', profile.id)
          .execute();
      }

      if (profile.isPregnant && profile.activePregnancyId) {
        const a = await trx
          .updateTable('pregnancy')
          .set({ isActive: false })
          .where('pregnancy.id', '=', profile.activePregnancyId)
          .returningAll()
          .executeTakeFirstOrThrow();
        console.log(a);
      }

      return {
        ...pregnancy,
        fetuses: fetusData,
      };
    });
  }

  async updatePregnancy(
    userId: string,
    pregnancyId: number,
    { fetuses, ...data }: CreatePregnancyInput,
  ) {
    return await this.db.transaction().execute(async (trx) => {
      const profile = await trx
        .selectFrom('pregnancy')
        .innerJoin('profile', 'profile.id', 'pregnancy.profileId')
        .selectAll('pregnancy')
        .select(['profile.id', 'profile.userId', 'profile.isPregnant'])
        .executeTakeFirstOrThrow();

      if (profile.userId !== userId) {
        throw new NotFoundException('Böyle bir hamilelik bulunamadı.');
      }

      const updatedPregnancy = await trx
        .updateTable('pregnancy')
        .set(data)
        .where('id', '=', pregnancyId)
        .where('isActive', '=', true)
        .returningAll()
        .executeTakeFirstOrThrow(
          () => new NotFoundException('Böyle bir hamilelik bulunamadı.'),
        );

      const fetusData = await trx
        .with('deleteFetuses', (db) =>
          db.deleteFrom('fetus').where('pregnancyId', '=', updatedPregnancy.id),
        )
        .insertInto('fetus')
        .values(
          fetuses.map((fetus) => ({ ...fetus, pregnancyId: pregnancyId })),
        )
        .returningAll()
        .execute();

      if (updatedPregnancy.birthGiven) {
        await trx
          .updateTable('profile')
          .where('id', '=', profile.id)
          .set({ isPregnant: false })
          .execute();
      }

      return {
        ...updatedPregnancy,
        fetuses: fetusData,
      };
    });
  }

  getPregnanciesQuery(userId: string) {
    const eb = expressionBuilder<DB, 'pregnancy'>();

    return eb
      .selectFrom('pregnancy')
      .selectAll('pregnancy')
      .innerJoin('profile', 'profile.id', 'pregnancy.profileId')
      .where('profile.userId', '=', userId);
  }

  getPregnancies(userId: string) {
    return (
      getPregnanciesQuery: SelectQueryBuilder<
        DB,
        'pregnancy',
        {
          id: number;
          profileId: number;
          endDate: Date | null;
          dueDate: Date;
          lastPeriodDate: Date | null;
          birthGiven: boolean;
          deliveryType: deliveryType;
          type: pregnancyType;
          isActive: boolean;
          notes: string | null;
        }
      >,
    ) => {
      return this.db.selectNoFrom((eb) => [
        eb
          .selectFrom('pregnancy')
          .innerJoin('profile', 'profile.id', 'pregnancy.profileId')
          .where('profile.userId', '=', userId)
          .select((eb) => [eb.fn.countAll<number>().as('total')])
          .as('total'),
        jsonArrayFrom(getPregnanciesQuery).as('data'),
      ]);
    };
  }
}

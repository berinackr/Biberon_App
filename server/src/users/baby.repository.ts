import { Injectable, NotFoundException } from '@nestjs/common';
import { Database } from '../database/database';
import { InjectKysely } from 'nestjs-kysely';
import { CreateBabyDto } from './dto/create-baby.dto';
import { UpdateBabyDto } from './dto/update-baby.dto';
import { jsonArrayFrom } from 'kysely/helpers/postgres';
import { SelectQueryBuilder, expressionBuilder } from 'kysely';
import { DB } from '../database/types';

@Injectable()
export class BabyRepository {
  constructor(@InjectKysely() private readonly db: Database) {}

  async createBaby(baby: CreateBabyDto, userId: string) {
    return await this.db
      .with('createBaby', (db) =>
        db
          .updateTable('profile')
          .where('userId', '=', userId)
          .set('isParent', true),
      )
      .insertInto('baby')
      .values((eb) => ({
        ...baby,
        updatedAt: new Date(),
        profileId: eb
          .selectFrom('profile')
          .where('profile.userId', '=', userId)
          .select('id'),
      }))
      .returningAll()
      .executeTakeFirstOrThrow();
  }

  getBabies(userId: string) {
    return (
      getBabiesQuery: SelectQueryBuilder<
        DB,
        'baby',
        {
          id: number;
          name: string;
          dateOfBirth: Date;
          profileId: number;
          gender: 'BOY' | 'GIRL' | 'UNKNOWN';
          birthTime: Date | null;
          birthWeight: number | null;
          birthHeight: number | null;
          notes: string | null;
        }
      >,
    ) => {
      return this.db.selectNoFrom((eb) => [
        eb
          .selectFrom('baby')
          .innerJoin('profile', 'profile.id', 'baby.profileId')
          .where('profile.userId', '=', userId)
          .select((eb) => [eb.fn.countAll<number>().as('total')])
          .as('total'),
        jsonArrayFrom(getBabiesQuery).as('data'),
      ]);
    };
  }

  getBabiesQuery(userId: string) {
    const eb = expressionBuilder<DB, 'baby'>();
    return eb
      .selectFrom('baby')
      .innerJoin('profile', 'profile.id', 'baby.profileId')
      .where('profile.userId', '=', userId)
      .selectAll('baby')
      .limit(10);
  }

  getTotalBabies(userId: string) {
    return this.db
      .selectFrom('baby')
      .select((eb) => [eb.fn.countAll<number>().as('total')])
      .innerJoin('profile', 'profile.id', 'baby.profileId')
      .where('profile.userId', '=', userId);
  }

  async getBaby(userId: string, babyId: number) {
    return await this.db
      .selectFrom('baby')
      .selectAll('baby')
      .innerJoin('profile', 'profile.id', 'baby.profileId')
      .where('profile.userId', '=', userId)
      .where('baby.id', '=', babyId)
      .executeTakeFirst();
  }

  async updateBaby(baby: UpdateBabyDto, userId: string, babyId: number) {
    return await this.db
      .updateTable('baby')
      .where('id', '=', babyId)
      .where(
        'profileId',
        'in',
        this.db.selectFrom('profile').select('id').where('userId', '=', userId),
      )
      .set(baby)
      .returning([
        'baby.birthHeight',
        'baby.birthWeight',
        'baby.dateOfBirth',
        'baby.id',
        'baby.name',
        'baby.dateOfBirth',
        'baby.profileId',
        'baby.notes',
        'baby.birthTime',
      ])
      .executeTakeFirstOrThrow(() => new NotFoundException());
  }

  async deleteBaby(userId: string, babyId: number) {
    return await this.db.transaction().execute(async (trx) => {
      const data = await trx
        .selectFrom('baby')
        .innerJoin('profile', 'profile.id', 'baby.profileId')
        .select('profile.userId')
        .where('baby.id', '=', babyId)
        .executeTakeFirstOrThrow(
          () => new NotFoundException('Böyle bir bebek bulunamadı.'),
        );

      if (data.userId !== userId) {
        throw new NotFoundException('Böyle bir bebek bulunamadı.');
      }

      await trx.deleteFrom('baby').where('baby.id', '=', babyId).execute();

      // Check if the user has any babies left if not, set isParent to false

      await trx
        .updateTable('profile')
        .set((eb) => ({
          isParent: eb
            .case()
            .when(
              eb.exists(
                eb
                  .selectFrom('baby')
                  .whereRef('baby.profileId', '=', 'profile.id'),
              ),
            )
            .then(true)
            .else(false)
            .end(),
        }))
        .where('userId', '=', userId)
        .execute();
    });
  }
}

import { BabyEntity } from './baby';
import { ApiProperty } from '@nestjs/swagger';
import { Exclude, Expose } from 'class-transformer';
import { PregnancyEntity } from './pregnancy';
import { CityEntity } from './city';
import { SpecializationEntity } from './specialization';
import { ProfileSelect } from '../../database/interfaces';

export class UserProfileEntity implements ProfileSelect {
  constructor({ babies, pregnancies, ...partial }: Partial<UserProfileEntity>) {
    Object.assign(this, partial);

    if (babies) {
      this.babies = babies.map((baby) => new BabyEntity(baby));
    }
    if (pregnancies) {
      this.pregnancies = pregnancies.map(
        (pregnancy) => new PregnancyEntity(pregnancy),
      );
    }
  }
  @ApiProperty({ type: String, nullable: true })
  bio!: string | null;
  @ApiProperty({ type: Number, nullable: true })
  specializationId!: number | null;
  @Exclude({ toPlainOnly: true })
  id!: number;
  @ApiProperty()
  userId!: string;
  @ApiProperty({ type: Number, nullable: true, example: 1 })
  @Expose({ groups: ['me', 'admin'] })
  cityId!: number | null;
  @ApiProperty({ type: Date, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  dateOfBirth!: Date | null;
  @ApiProperty({ type: String, nullable: true })
  name!: string | null;
  @ApiProperty({ type: Boolean, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  isPregnant!: boolean | null;
  @ApiProperty({ type: Boolean, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  isParent!: boolean | null;
  @ApiProperty({ type: BabyEntity, isArray: true })
  @Expose({ groups: ['me', 'admin'] })
  babies!: BabyEntity[];
  @ApiProperty({ type: PregnancyEntity, isArray: true })
  @Expose({ groups: ['me', 'admin'] })
  pregnancies!: PregnancyEntity[];
  @ApiProperty({ type: CityEntity, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  city!: CityEntity | null;
  @ApiProperty({ type: SpecializationEntity, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  specialization!: SpecializationEntity | null;
}

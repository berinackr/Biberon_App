import { ApiProperty } from '@nestjs/swagger';
import { Exclude, Expose } from 'class-transformer';
import { FetusEntity } from './fetus';
import { deliveryType, pregnancyType } from '../../database/enums';
import { PregnancySelect } from '../../database/interfaces';

export class PregnancyEntity implements PregnancySelect {
  constructor({ fetuses, ...partial }: Partial<PregnancyEntity>) {
    Object.assign(this, partial);

    if (fetuses) {
      this.fetuses = fetuses.map((fetus) => new FetusEntity(fetus));
    }
  }
  @ApiProperty({ enum: deliveryType, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  deliveryType!: deliveryType | null;
  @ApiProperty({ type: Boolean })
  @Expose({ groups: ['me', 'admin'] })
  isActive!: boolean;
  @ApiProperty({ type: String, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  notes!: string | null;
  @ApiProperty({ type: Number })
  id!: number;
  @Exclude({ toPlainOnly: true })
  profileId!: number;
  @ApiProperty({ type: Date, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  endDate!: Date | null;
  @ApiProperty({ type: Date })
  @Expose({ groups: ['me', 'admin'] })
  dueDate!: Date;
  @ApiProperty({ type: Date, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  lastPeriodDate!: Date | null;
  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  birthGiven!: boolean;
  @ApiProperty({ enum: pregnancyType })
  @Expose({ groups: ['me', 'admin'] })
  type!: pregnancyType;
  @ApiProperty({ type: FetusEntity, isArray: true })
  @Expose({ groups: ['me', 'admin'] })
  fetuses!: FetusEntity[];
}

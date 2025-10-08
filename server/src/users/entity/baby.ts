import { ApiProperty } from '@nestjs/swagger';
import { Exclude, Expose } from 'class-transformer';
import { BabySelect } from '../../database/interfaces';
import { gender } from '../../database/enums';

export class BabyEntity implements BabySelect {
  constructor(partial: Partial<BabyEntity>) {
    Object.assign(this, partial);
  }
  @Expose({ groups: ['me', 'admin'] })
  @ApiProperty({ type: String, nullable: true })
  notes!: string | null;
  @ApiProperty({ type: Number })
  id!: number;
  @Exclude({ toPlainOnly: true })
  profileId!: number;
  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  gender!: gender;
  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  dateOfBirth!: Date;
  @ApiProperty({ type: Date, nullable: true })
  @Expose({ groups: ['me', 'admin'] })
  birthTime!: Date | null;
  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  name!: string;
  @ApiProperty({
    type: Number,
    nullable: true,
    example: 3200,
    description: 'gram',
  })
  @Expose({ groups: ['me', 'admin'] })
  birthWeight!: number | null;
  @ApiProperty({ type: Number, nullable: true, example: 50, description: 'cm' })
  @Expose({ groups: ['me', 'admin'] })
  birthHeight!: number | null;
  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  createdAt!: Date;
  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  updatedAt!: Date;
}

import { ApiProperty } from '@nestjs/swagger';
import { Exclude, Expose } from 'class-transformer';
import { FetusSelect } from '../../database/interfaces';
import { gender } from '../../database/enums';

export class FetusEntity implements FetusSelect {
  constructor(partial: Partial<FetusEntity>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  id!: number;
  @Exclude({ toPlainOnly: true })
  pregnancyId!: number;
  @ApiProperty({ enum: gender })
  @Expose({ groups: ['me', 'admin'] })
  gender!: gender;
}

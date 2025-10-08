import { ApiProperty } from '@nestjs/swagger';
import { SpecializationSelect } from '../../database/interfaces';

export class SpecializationEntity implements SpecializationSelect {
  constructor(partial: Partial<SpecializationEntity>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  id!: number;
  @ApiProperty()
  name!: string;
}

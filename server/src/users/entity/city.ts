import { ApiProperty } from '@nestjs/swagger';
import { CitySelect } from '../../database/interfaces';

export class CityEntity implements CitySelect {
  constructor(partial: Partial<CityEntity>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  id!: number;
  @ApiProperty()
  name!: string;
}

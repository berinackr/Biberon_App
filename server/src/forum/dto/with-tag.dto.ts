import { ApiProperty } from '@nestjs/swagger';

export class WithTag {
  constructor(partial: Partial<WithTag>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  id!: number;
  @ApiProperty()
  name!: string;
}

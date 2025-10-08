import { ApiProperty } from '@nestjs/swagger';

export class PageMetaDto {
  constructor({ ...data }: PageMetaDto) {
    Object.assign(this, data);
  }

  @ApiProperty()
  total!: number;
  @ApiProperty()
  lastPage!: number;
  @ApiProperty()
  currentPage!: number;
  @ApiProperty()
  perPage!: number;
  @ApiProperty({ type: Number, nullable: true })
  prev!: number | null;
  @ApiProperty({ type: Number, nullable: true })
  next!: number | null;
}

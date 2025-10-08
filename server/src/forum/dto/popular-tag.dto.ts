import { Type } from 'class-transformer';
import { PostTagModel } from '../models/tag.model';
import { ApiProperty } from '@nestjs/swagger';

export class PopularTag extends PostTagModel {
  constructor(partial: Partial<PopularTag>) {
    super(partial);
    Object.assign(this, partial);
  }
  @ApiProperty()
  @Type(() => Number)
  postCount!: number | string;
}

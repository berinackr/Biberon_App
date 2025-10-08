import { ApiProperty } from '@nestjs/swagger';
import { TagSelect } from '../../database/interfaces';
import { Exclude } from 'class-transformer';

export class PostTagModel implements TagSelect {
  constructor(partial: Partial<PostTagModel>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  id!: number;
  @ApiProperty()
  name!: string;
  @Exclude()
  createdAt!: Date;
  @Exclude()
  updatedAt!: Date;
}

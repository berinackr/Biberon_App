import { ApiProperty } from '@nestjs/swagger';
import { GeneralResponseDto } from '../../common/dto/general-response.dto';
import { PostDetailsWithLikesAndTags } from './post-details.dto';
import { Type } from 'class-transformer';

export class PostFeed extends GeneralResponseDto {
  constructor(data: PostFeed) {
    super(data);
    this.data = data.data;
  }
  @ApiProperty({ type: PostDetailsWithLikesAndTags, isArray: true })
  @Type(() => PostDetailsWithLikesAndTags)
  data!: PostDetailsWithLikesAndTags[];
}

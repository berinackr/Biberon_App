import { ApiProperty } from '@nestjs/swagger';
import { PostVoteSelect } from '../../database/interfaces';

export class PostVoteModel implements PostVoteSelect {
  constructor(partial: Partial<PostVoteModel>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  voteTypeId!: number;
  @ApiProperty()
  postId!: string;
  @ApiProperty()
  userId!: string;
}

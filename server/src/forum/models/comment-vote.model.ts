import { ApiProperty } from '@nestjs/swagger';
import { CommentVoteSelect } from '../../database/interfaces';

export class CommentVoteModel implements CommentVoteSelect {
  constructor(partial: Partial<CommentVoteModel>) {
    Object.assign(this, partial);
  }

  @ApiProperty()
  voteTypeId!: number;
  @ApiProperty()
  commentId!: string;
  @ApiProperty()
  userId!: string;
}

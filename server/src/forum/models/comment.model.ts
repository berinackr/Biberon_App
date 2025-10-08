import { ApiProperty } from '@nestjs/swagger';
import { CommentSelect } from '../../database/interfaces';
import { QuillDelta } from '../../utils/types/delta-quill.type';

export class CommentModel implements CommentSelect {
  constructor(partial: Partial<CommentModel>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  id!: string;
  @ApiProperty()
  postId!: string;
  @ApiProperty()
  userId!: string | null;
  @ApiProperty()
  body!: string;
  @ApiProperty()
  richText!: QuillDelta;
  @ApiProperty()
  createdAt!: Date;
  @ApiProperty()
  updatedAt!: Date;
}

import { ApiProperty } from '@nestjs/swagger';
import { PostSelect } from './../../database/interfaces';
import { QuillDelta } from '../../utils/types/delta-quill.type';
export class PostModel implements PostSelect {
  constructor(partial: Partial<PostModel>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  selectedAnswerId!: string | null;
  postId!: string | null;
  @ApiProperty()
  postTypeId!: number;
  @ApiProperty()
  slug!: string | null;
  @ApiProperty({ type: Date })
  lastActivityDate!: Date;
  @ApiProperty()
  id!: string;
  @ApiProperty()
  title!: string | null;
  @ApiProperty()
  body!: string;
  @ApiProperty()
  richText!: QuillDelta;
  @ApiProperty({
    type: String,
    nullable: true,
    description:
      'When post is a answer to another post this field will not be null',
  })
  parentId!: string | null;
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'When users account deleted this field will be null',
  })
  userId!: string | null;
  @ApiProperty({ type: Date })
  createdAt!: Date;
  @ApiProperty({ type: Date })
  updatedAt!: Date;
}

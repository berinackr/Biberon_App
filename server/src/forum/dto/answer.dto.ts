import { ApiProperty } from '@nestjs/swagger';
import { ToShortUuid } from '../../common/decorators/toshortuuid.decorator';
import { WithUser } from './with-user.dto';
import { Transform, Type } from 'class-transformer';
import { CommentDto } from './comment.dto';
import { QuillDelta } from '../../utils/types/delta-quill.type';

export class AnswerDto {
  constructor({ ...partial }: Partial<AnswerDto>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  @ToShortUuid()
  id!: string;
  @ApiProperty()
  richText!: QuillDelta;
  @ApiProperty()
  body!: string;
  @ApiProperty()
  createdAt!: Date;
  @ApiProperty()
  updatedAt!: Date;
  @ApiProperty({ type: [WithUser], nullable: true })
  user!: WithUser | null;
  @ApiProperty()
  @ToShortUuid()
  parentId!: string;
  @ApiProperty({ type: Number })
  @Transform(({ value }) => Number(value))
  totalVote!: number | string;
  @ApiProperty({ type: Number })
  @Transform(({ value }) => Number(value))
  totalLike!: number | string;
  @ApiProperty({ type: Number })
  @Transform(({ value }) => Number(value))
  totalSmiley!: number | string;
  @ApiProperty({ type: Number })
  @Transform(({ value }) => Number(value))
  totalClap!: number | string;
  @ApiProperty({ type: Number })
  @Transform(({ value }) => Number(value))
  totalHeart!: number | string;
  @ApiProperty({ type: Number })
  @Transform(({ value }) => Number(value))
  totalCommentCount!: number | string;
  @ApiProperty({ type: Number, nullable: true, required: false })
  userVote!: number | null | undefined;
  @ApiProperty({ type: CommentDto, isArray: true })
  @Type(() => CommentDto)
  comments!: CommentDto[];
}

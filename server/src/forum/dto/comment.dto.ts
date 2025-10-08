import { ApiProperty } from '@nestjs/swagger';
import { ToShortUuid } from '../../common/decorators/toshortuuid.decorator';
import { WithUser } from './with-user.dto';
import { Transform } from 'class-transformer';
import { QuillDelta } from '../../utils/types/delta-quill.type';

export class CommentDto {
  @ApiProperty()
  @ToShortUuid()
  id!: string;
  @ApiProperty()
  @ToShortUuid()
  postId!: string;
  @ApiProperty()
  body!: string;
  @ApiProperty()
  richText!: QuillDelta;
  @ApiProperty()
  createdAt!: Date;
  @ApiProperty()
  updatedAt!: Date;
  @ApiProperty({ type: [WithUser], nullable: true })
  user!: WithUser | null;
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
  @ApiProperty({ type: Number, nullable: true, required: false })
  userVote!: number | null | undefined;
}

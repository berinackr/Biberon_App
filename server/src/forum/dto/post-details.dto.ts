import { ApiProperty } from '@nestjs/swagger';
import { ToShortUuid } from '../../common/decorators/toshortuuid.decorator';
import { Transform, Type } from 'class-transformer';
import { WithUser } from './with-user.dto';
import { WithTag } from './with-tag.dto';
import { AnswerDto } from './answer.dto';
import { SqlBool } from 'kysely';
import { DeltaOperation } from './quill-delta.dto';

export class PostDetailsDto {
  constructor({ ...partial }: Partial<PostDetailsDto>) {
    Object.assign(this, partial);
  }

  @ApiProperty()
  @ToShortUuid()
  id!: string;
  @ApiProperty()
  title!: string;
  @ApiProperty()
  body!: string;
  @ApiProperty({ isArray: true, type: DeltaOperation })
  richText!: DeltaOperation[];
  @ApiProperty()
  createdAt!: Date;
  @ApiProperty()
  updatedAt!: Date;
  @ApiProperty()
  lastActivityDate!: Date;
  @ApiProperty()
  slug!: string;
  @ApiProperty({ type: Number })
  @Transform(({ value }) => Number(value))
  totalAnswerCount!: number | string;

  @ApiProperty({ type: Number, nullable: true, required: false })
  userVote!: number | null | undefined;

  @ApiProperty({ type: Boolean, required: false })
  bookmarked!: SqlBool | undefined;

  @ApiProperty({ type: [WithUser], nullable: true })
  user!: WithUser | null;

  @ApiProperty({ type: Boolean })
  isAnswered!: SqlBool;
}

export class PostDetailsWithTags extends PostDetailsDto {
  @ApiProperty({ type: [WithTag] })
  tags!: WithTag[];
}

export class PostDetailsWithLikes extends PostDetailsDto {
  constructor({ ...partial }: Partial<PostDetailsWithLikes>) {
    super(partial);
  }
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
}

export class PostDetailsWithLikesAndTags extends PostDetailsWithLikes {
  constructor({ ...partial }: Partial<PostDetailsWithLikesAndTags>) {
    super(partial);
  }
  @ApiProperty({ type: [WithTag] })
  tags!: WithTag[];
}

export class PostDetailsWithComments extends PostDetailsDto {
  constructor({ ...partial }: Partial<PostDetailsWithComments>) {
    super(partial);
  }
  @ApiProperty({ type: [AnswerDto], isArray: true })
  answers!: AnswerDto[];
}

export class PostDetailsWithEverything extends PostDetailsDto {
  constructor({ ...partial }: Partial<PostDetailsWithEverything>) {
    super(partial);
  }
  @ApiProperty({ type: [WithTag] })
  tags!: WithTag[];
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
  @ApiProperty({ type: AnswerDto, isArray: true })
  @Type(() => AnswerDto)
  answers!: AnswerDto[];
  @ApiProperty({ type: AnswerDto, required: false, nullable: true })
  @Type(() => AnswerDto)
  selectedAnswer!: AnswerDto | null;
}

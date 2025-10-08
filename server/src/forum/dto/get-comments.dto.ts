import { ApiProperty } from '@nestjs/swagger';
import { CommentDto } from './comment.dto';
import { Type } from 'class-transformer';

export class GetCommentDto {
  constructor(data: GetCommentDto) {
    this.data = data.data;
    this.message = data.message;
    this.status = data.status;
  }
  @ApiProperty({ type: CommentDto, isArray: true })
  @Type(() => CommentDto)
  data!: CommentDto[];
  @ApiProperty()
  status!: string;
  @ApiProperty()
  message!: string;
}

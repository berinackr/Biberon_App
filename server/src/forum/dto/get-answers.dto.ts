import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { AnswerDto } from './answer.dto';

export class GetAnswersDto {
  constructor(data: GetAnswersDto) {
    this.data = data.data;
    this.message = data.message;
    this.status = data.status;
  }
  @ApiProperty({ type: AnswerDto, isArray: true })
  @Type(() => AnswerDto)
  data!: AnswerDto[];
  @ApiProperty()
  status!: string;
  @ApiProperty()
  message!: string;
}

import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsNumber, Max, Min } from 'class-validator';

export class VoteQueryDto {
  @ApiProperty()
  @IsNumber({}, { message: 'Geçersiz' })
  @Min(1, { message: 'Geçersiz' })
  @Max(5, { message: 'Geçersiz' })
  @Transform(({ value }) => parseInt(value))
  vote_type_id!: number;
}

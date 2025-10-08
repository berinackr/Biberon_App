import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsDate, IsNotEmpty, MaxDate } from 'class-validator';

export class BirthDto {
  @IsNotEmpty()
  @MaxDate(new Date(), { message: 'Doğum tarihi bugünden büyük olamaz' })
  @IsDate()
  @ApiProperty()
  @Transform(({ value }) => (value ? new Date(value) : value))
  birthDate!: Date;
}

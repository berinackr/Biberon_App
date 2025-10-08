import { ApiProperty } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';
import { gender } from '../../database/enums';

export class CreateFetusDto {
  @ApiProperty({ enum: gender })
  @IsEnum(gender, { message: 'Geçerli bir cinsiyet girilmelidir.' })
  gender!: gender;
}

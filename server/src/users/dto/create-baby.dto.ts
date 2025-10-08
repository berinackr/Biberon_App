import { ApiProperty } from '@nestjs/swagger';
import {
  IsDate,
  IsEnum,
  IsMilitaryTime,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsPositive,
  IsString,
  Max,
  MaxDate,
  MaxLength,
  Min,
  MinLength,
  Validate,
} from 'class-validator';
import { Transform } from 'class-transformer';
import { Trim } from '../../common/decorators/trim.decorator';
import { IsNullable } from '../../common/decorators/nullable.decorator';
import { IsGenderNotUnknown } from '../../common/decorators/validators/unknown-gender.decorator';
import { gender } from '../../database/enums';

export class CreateBabyDto {
  @ApiProperty({ enum: gender })
  @IsNotEmpty({ message: 'Cinsiyet boş bırakılamaz.' })
  @IsEnum(gender, { message: 'Geçerli bir cinsiyet girilmelidir.' })
  @Validate(IsGenderNotUnknown, {
    message: 'Cinsiyet bilinmiyor olamaz.',
  })
  gender!: gender;
  @ApiProperty()
  @IsDate({ message: 'Doğum tarihi geçerli bir tarih olmalıdır.' })
  @MaxDate(new Date(), { message: 'Doğum tarihi bugünden büyük olamaz.' })
  @IsNotEmpty({ message: 'Doğum tarihi boş bırakılamaz.' })
  @Transform(({ value }) => (value ? new Date(value) : value))
  dateOfBirth!: Date;
  @ApiProperty({ example: '21:02', nullable: true })
  @IsOptional()
  @IsNullable()
  @IsMilitaryTime({ message: 'Doğum zamanı geçerli bir tarih olmalıdır' })
  birthTime?: Date;
  @ApiProperty({ example: 'John' })
  @IsNotEmpty({ message: 'İsim boş bırakılamaz.' })
  @IsString({ message: 'İsim geçerli bir isim olmalıdır.' })
  @MinLength(2, { message: 'İsim en az 2 karakter olmalıdır.' })
  @MaxLength(64, { message: 'İsim en fazla 64 karakter olmalıdır.' })
  @Trim()
  name!: string;
  @ApiProperty({ example: 3200, description: 'Kg' })
  @IsOptional()
  @IsNullable()
  @IsNumber(
    { maxDecimalPlaces: 2 },
    { message: 'Doğum ağırlığı geçerli bir sayı olmalıdır.' },
  )
  @IsPositive({ message: 'Doğum ağırlığı pozitif bir sayı olmalıdır.' })
  birthWeight?: number;
  @ApiProperty({ example: 50, description: 'Cm' })
  @IsNullable()
  @IsPositive({ message: 'Doğum boyu pozitif bir sayı olmalıdır.' })
  @IsOptional()
  @IsNumber(
    { maxDecimalPlaces: 2 },
    { message: 'Doğum boyu geçerli bir sayı olmalıdır.' },
  )
  @Min(10, { message: 'Geçerli bir doğum boyu girilmelidir.' })
  @Max(75, { message: 'Geçerli bir doğum boyu girilmelidir.' })
  birthHeight?: number;

  @ApiProperty()
  @IsOptional()
  @IsNullable()
  @IsString({ message: 'Notlar kısmı geçerli bir not olmalıdır.' })
  @MinLength(1, { message: 'Notlar kısmı en az 1 karakter olmalıdır.' })
  @MaxLength(1500, { message: 'Notlar kısmı en fazla 255 karakter olmalıdır.' })
  @Trim()
  notes?: string;
}

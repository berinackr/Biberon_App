import { ApiProperty } from '@nestjs/swagger';
import {
  IsNotEmpty,
  IsNumber,
  Min,
  Max,
  MaxDate,
  IsDate,
  IsString,
  MinLength,
  MaxLength,
} from 'class-validator';
import { Type } from 'class-transformer';
import { IsNullable } from '../../common/decorators/nullable.decorator';
import { Trim } from '../../common/decorators/trim.decorator';

export class UpdateUserProfileDto {
  @ApiProperty({
    example: new Date(new Date().setFullYear(new Date().getFullYear() - 18)),
  })
  @IsNullable()
  @IsNotEmpty({ message: 'Doğum tarihi boş bırakılamaz.' })
  @IsDate({ message: 'Doğum tarihi geçerli bir tarih olmalıdır.' })
  // kullanıcı 18 yaşından büyük olmalıdır
  @MaxDate(new Date(new Date().setFullYear(new Date().getFullYear() - 18)), {
    message: 'Kullanıcı 18 yaşından büyük olmalıdır.',
  })
  @Type(() => Date)
  dateOfBirth!: Date | null;

  @ApiProperty({ example: 1 })
  @IsNullable()
  @IsNumber(
    { allowNaN: false, allowInfinity: false, maxDecimalPlaces: 0 },
    { message: 'Geçerli bir şehir bilgisi girilmelidir.' },
  )
  @Min(1, { message: 'Geçerli bir şehir bilgisi girilmelidir.' })
  @Max(81, { message: 'Geçerli bir şehir bilgisi girilmelidir.' })
  cityId!: number | null;

  @ApiProperty({ type: String, nullable: true })
  @IsNullable()
  @IsString({ message: 'İsim geçerli bir isim olmalıdır.' })
  @MinLength(2, { message: 'İsim en az 2 karakter olmalıdır.' })
  @MaxLength(64, { message: 'İsim en fazla 64 karakter olmalıdır.' })
  @Trim()
  name!: string | null;

  @ApiProperty({ type: String, nullable: true })
  @IsNullable()
  @IsString({ message: 'Biyografi geçerli bir biyografi olmalıdır.' })
  @MinLength(1, { message: 'Biyografi en az 1 karakter olmalıdır.' })
  @MaxLength(255, { message: 'Biyografi en fazla 255 karakter olmalıdır.' })
  @Trim()
  bio!: string | null;
}

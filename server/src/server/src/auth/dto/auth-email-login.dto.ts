import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, MaxLength, MinLength } from 'class-validator';
import { Transform } from 'class-transformer';
import { lowerCaseTransformer } from '../../utils/transformers/lower-case.transformer';
import { Trim } from '../../common/decorators/trim.decorator';

export class AuthEmailLoginDto {
  @ApiProperty({ example: 'test1@example.com' })
  @Transform(lowerCaseTransformer)
  @IsEmail({}, { message: 'Lütfen geçerli bir mail adresi giriniz.' })
  @IsNotEmpty({ message: 'Mail adresi boş olamaz.' })
  @Trim()
  email!: string;

  @ApiProperty({ example: 'password', minLength: 8, maxLength: 64 })
  @MinLength(8, { message: 'Şifre en az 8 karakter olmalıdır.' })
  @MaxLength(64, { message: 'Şifre en fazla 64 karakter olmalıdır.' })
  @IsNotEmpty({ message: 'Şifre boş olamaz.' })
  @Trim()
  password!: string;
}

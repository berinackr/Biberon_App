import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsNotEmpty,
  Matches,
  MaxLength,
  MinLength,
} from 'class-validator';
import { Transform } from 'class-transformer';
import { lowerCaseTransformer } from '../../utils/transformers/lower-case.transformer';
import { Trim } from '../../common/decorators/trim.decorator';

export class AuthEmailRegisterDto {
  @ApiProperty({ example: 'test@example.com' })
  @Transform(lowerCaseTransformer)
  @IsEmail({}, { message: 'Lütfen geçerli bir mail adresi giriniz.' })
  @IsNotEmpty({ message: 'Mail adresi boş olamaz.' })
  @Trim()
  email!: string;

  @ApiProperty({ minLength: 8, maxLength: 64 })
  @MinLength(8, { message: 'Şifre en az 8 karakter olmalıdır.' })
  @MaxLength(64, { message: 'Şifre en fazla 64 karakter olmalıdır.' })
  @IsNotEmpty({ message: 'Şifre boş olamaz.' })
  @Trim()
  password!: string;

  @ApiProperty({ minLength: 2, maxLength: 20 })
  @Matches(/^[a-z0-9]+(-[a-z0-9]+)*$/, {
    message: 'İsim sadece küçük harf ve sayılardan oluşabilir.',
  })
  @MinLength(2, { message: 'İsim en az 2 karakterden oluşmalıdır.' })
  @MaxLength(20, { message: 'İsim en fazla 20 karakterden oluşmalıdır.' })
  @IsNotEmpty({ message: 'İsim boş olamaz.' })
  @Trim()
  username!: string;
}

import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, Length, MaxLength, MinLength } from 'class-validator';
import { Trim } from '../../common/decorators/trim.decorator';

export class ResetPasswordDto {
  @ApiProperty({ minLength: 8, maxLength: 64 })
  @MinLength(8, { message: 'Şifre en az 8 karakter olmalıdır.' })
  @MaxLength(64, { message: 'Şifre en fazla 64 karakter olmalıdır.' })
  @IsNotEmpty({ message: 'Şifre boş olamaz.' })
  @Trim()
  password!: string;

  @ApiProperty({ description: 'Token', minLength: 32, maxLength: 32 })
  @IsNotEmpty({ message: 'Geçersiz istek' })
  @Length(32, 32, { message: 'Geçersiz istek' })
  @Trim()
  token!: string;
}

import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, MaxLength, MinLength } from 'class-validator';

export class CreateUserDto {
  @ApiProperty({ example: 'test@biberonapp.com' })
  @IsNotEmpty({ message: 'Email alanı boş olamaz' })
  @IsEmail({}, { message: 'Geçerli bir email adresi giriniz' })
  email!: string;

  @ApiProperty({ example: 'password' })
  @IsNotEmpty()
  @MinLength(8, { message: 'Şifre en az 8 karakterden oluşmalıdır' })
  @MaxLength(64, { message: 'Şifre en fazla 64 karakterden oluşmalıdır' })
  password!: string;

  @ApiProperty({ example: 'John' })
  @IsNotEmpty({ message: 'İsim alanı boş olamaz' })
  @MinLength(2, { message: 'İsim en az 2 karakterden oluşmalıdır' })
  @MaxLength(64, { message: 'İsim en fazla 64 karakterden oluşmalıdır' })
  username!: string;
}

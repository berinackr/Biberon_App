import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';
import { lowerCaseTransformer } from '../../utils/transformers/lower-case.transformer';
import { Transform } from 'class-transformer';
import { Trim } from '../../common/decorators/trim.decorator';

export class ForgotPasswordDto {
  @ApiProperty({ example: 'test@example.com' })
  @Transform(lowerCaseTransformer)
  @IsEmail({}, { message: 'Lütfen geçerli bir mail adresi giriniz' })
  @IsNotEmpty({ message: 'Mail adresi boş olamaz' })
  @Trim()
  email!: string;
}

import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumberString, Length } from 'class-validator';
import { Trim } from '../../common/decorators/trim.decorator';

export class AuthConfirmEmailDto {
  @ApiProperty()
  @IsNotEmpty()
  @Trim()
  @IsNumberString(undefined, { message: 'Kod sayısal bir değer olmalıdır.' })
  @Length(6, 6, { message: 'Kod 6 karakterden oluşmalıdır.' })
  code!: string;
}

import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';
import { Trim } from '../../common/decorators/trim.decorator';

export class AuthGoogleLoginDto {
  @ApiProperty()
  @IsNotEmpty({ message: 'id gereklidir' })
  @Trim()
  idToken!: string;
}

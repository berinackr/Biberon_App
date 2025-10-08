import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MaxLength } from 'class-validator';
import { Trim } from '../../common/decorators/trim.decorator';

export class UploadedImageDto {
  @ApiProperty({ type: String })
  @IsString({ message: 'Resim keyi geçerli bir URL olmalıdır.' })
  @IsNotEmpty({ message: 'Resim keyi boş bırakılamaz.' })
  @MaxLength(255, { message: 'Resim keyi en fazla 255 karakter olmalıdır.' })
  @Trim()
  key!: string;
}

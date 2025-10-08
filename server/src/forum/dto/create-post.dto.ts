import { ApiProperty } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  ArrayNotEmpty,
  IsArray,
  IsNotEmpty,
  IsNumber,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';
import { IsQuillDelta } from '../../common/decorators/validators/is-quill-delta.decorator';
import { DeltaOperation } from './quill-delta.dto';

export class CreatePostDto {
  @ApiProperty()
  @IsNotEmpty({ message: 'Başlık boş bırakılamaz.' })
  @MinLength(1, { message: 'Başlık en az 1 karakter olmalıdır.' })
  @MaxLength(150, { message: 'Başlık en fazla 150 karakter olmalıdır.' })
  title!: string;
  @ApiProperty({ isArray: true, type: DeltaOperation })
  @IsNotEmpty({ message: 'Cevap boş bırakılamaz.' })
  @ArrayNotEmpty({ message: 'Cevap boş bırakılamaz.' })
  @ArrayMinSize(1, { message: 'Cevap boş bırakılamaz.' })
  @IsQuillDelta({ message: 'Cevap geçerli bir Quill Delta olmalıdır.' })
  richText!: DeltaOperation[];
  @ApiProperty({ type: [Number] })
  @IsNotEmpty({ message: 'Etiket kısmı boş bırakılamaz' })
  @IsArray({ message: 'Geçerli bir etiket girilmelidir' })
  @ArrayNotEmpty({ message: 'En az bir etiket girilmelidir' })
  @IsNumber(
    { maxDecimalPlaces: 0 },
    { each: true, message: 'Geçerli bir etiket girilmelidir' },
  )
  @Min(1, { each: true, message: 'Geçerli bir etiket girilmelidir' })
  @ArrayMaxSize(2, { message: 'En fazla 2 etiket girilebilir' })
  tags!: number[];
}

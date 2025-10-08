import { ApiProperty } from '@nestjs/swagger';
import { ArrayMinSize, ArrayNotEmpty, IsNotEmpty } from 'class-validator';
import { IsQuillDelta } from '../../common/decorators/validators/is-quill-delta.decorator';
import { DeltaOperation } from './quill-delta.dto';

export class CreateAnswerDto {
  @ApiProperty({ isArray: true, type: DeltaOperation })
  @IsNotEmpty({ message: 'Cevap boş bırakılamaz.' })
  @ArrayNotEmpty({ message: 'Cevap boş bırakılamaz.' })
  @ArrayMinSize(1, { message: 'Cevap boş bırakılamaz.' })
  @IsQuillDelta({ message: 'Cevap geçerli bir Quill Delta olmalıdır.' })
  richText!: DeltaOperation[];
}

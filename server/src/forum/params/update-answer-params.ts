import { IsString, IsUUID } from 'class-validator';
import { FromShortUuid } from '../../common/decorators/fromshortuuid.decorator';

export class UpdateAnswerParams {
  @IsString()
  @IsUUID()
  @FromShortUuid()
  id!: string;

  @IsString()
  @IsUUID()
  @FromShortUuid()
  answerId!: string;
}

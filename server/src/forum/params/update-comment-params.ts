import { IsString, IsUUID } from 'class-validator';
import { FromShortUuid } from '../../common/decorators/fromshortuuid.decorator';

export class UpdateCommentParams {
  @IsString()
  @IsUUID()
  @FromShortUuid()
  id!: string;

  @IsString()
  @IsUUID()
  @FromShortUuid()
  commentId!: string;
}

import { IsString, IsUUID } from 'class-validator';
import { FromShortUuid } from '../../common/decorators/fromshortuuid.decorator';

export class PostFindOneParams {
  @IsString()
  @IsUUID()
  @FromShortUuid()
  id!: string;
}

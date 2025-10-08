import { ApiProperty } from '@nestjs/swagger';
import { ToShortUuid } from '../../common/decorators/toshortuuid.decorator';

export class CreatePostResponse {
  constructor(partial: Partial<CreatePostResponse>) {
    Object.assign(this, partial);
  }
  @ApiProperty()
  @ToShortUuid()
  id!: string;
}

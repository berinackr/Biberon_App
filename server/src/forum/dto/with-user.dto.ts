import { ApiProperty } from '@nestjs/swagger';
import { ToShortUuid } from '../../common/decorators/toshortuuid.decorator';

export class WithUser {
  constructor(partial: Partial<WithUser>) {
    Object.assign(this, partial);
  }

  @ApiProperty()
  @ToShortUuid()
  id!: string;
  @ApiProperty()
  username!: string;
  @ApiProperty({ nullable: true, type: String })
  avatarPath!: string | null;
}

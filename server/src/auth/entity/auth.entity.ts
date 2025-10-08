import { ApiProperty } from '@nestjs/swagger';
import { UserInfo } from 'src/users/entity/user-info';
import { UserEntity } from '../../users/entity/user';

export class AuthEntity {
  constructor({ user, ...data }: Partial<AuthEntity>) {
    Object.assign(this, data);

    if (user) {
      this.user = new UserEntity(user);
    }
  }
  @ApiProperty()
  token!: string;
  @ApiProperty()
  refreshToken!: string;
  @ApiProperty()
  expiresAt!: Date;
  @ApiProperty({ type: UserInfo })
  user!: UserInfo;
}

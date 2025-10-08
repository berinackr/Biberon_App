import { ApiProperty } from '@nestjs/swagger';
import { Exclude, Expose } from 'class-transformer';
import { UserSelect } from '../../database/interfaces';
import { provider, role } from '../../database/enums';

export class UserEntity implements UserSelect {
  constructor(partial: Partial<UserEntity>) {
    Object.assign(this, partial);
  }
  @Exclude()
  avatarUploadRequestedAt!: Date | null;
  @ApiProperty({ type: String, nullable: true })
  avatarPath!: string | null;
  @ApiProperty({ type: Date, nullable: true })
  avatarUpdatedAt!: Date | null;
  @ApiProperty()
  id!: string;

  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  email!: string;

  @ApiProperty()
  @Exclude({ toPlainOnly: true })
  password!: string | null;

  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  provider!: provider;

  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  socialId!: string | null;
  @ApiProperty({
    enum: role,
    type: 'string',
  })
  @Expose({ groups: ['me', 'admin'] })
  role!: role;
  @ApiProperty()
  username!: string;
  @ApiProperty()
  displayName!: string;
  @ApiProperty()
  createdAt!: Date;
  @ApiProperty()
  updatedAt!: Date;
  @ApiProperty()
  @Expose({ groups: ['me', 'admin'] })
  emailVerified!: boolean;
}

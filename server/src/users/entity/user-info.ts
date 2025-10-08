import { PickType } from '@nestjs/swagger';
import { UserEntity } from './user';

export class UserInfo extends PickType(UserEntity, [
  'id',
  'email',
  'username',
  'role',
  'emailVerified',
  'avatarPath',
] as const) {}

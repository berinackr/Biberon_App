import { UserInfo } from '../../../users/entity/user-info';

export type JwtPayloadType = UserInfo & {
  iat: number;
  exp: number;
};

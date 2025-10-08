import { UserInfo } from 'src/users/entity/user-info';

export type LoginResponseType = Readonly<{
  token: string;
  refreshToken: string;
  tokenExpires: number;
  user: UserInfo;
}>;

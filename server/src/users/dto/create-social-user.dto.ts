import { provider } from '../../database/enums';

export class CreateSocialUserDto {
  socialId!: string;

  provider!: provider;

  email!: string;

  username!: string;
}

import { SetMetadata } from '@nestjs/common';
import { role } from '../../database/enums';

export const Roles = (...roles: role[]) => SetMetadata('roles', roles);

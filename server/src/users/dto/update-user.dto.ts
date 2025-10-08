import { PartialType } from '@nestjs/swagger';
import { UserEntity } from '../entity/user';

export class UpdateUserDto extends PartialType(UserEntity) {}

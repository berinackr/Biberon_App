import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsDate, IsUUID, ValidateIf } from 'class-validator';
import { FromShortUuid } from '../../common/decorators/fromshortuuid.decorator';

export class GetCommentsQuery {
  @ValidateIf((o) => o.keyId)
  @ApiPropertyOptional({ type: Date, nullable: true })
  @IsDate()
  @Transform(({ value }) => (value ? new Date(value) : value))
  createdAt?: Date;
  @ValidateIf((o) => o.createdAt)
  @ApiPropertyOptional({ type: String, nullable: true })
  @IsUUID()
  @FromShortUuid()
  keyId?: string;
}

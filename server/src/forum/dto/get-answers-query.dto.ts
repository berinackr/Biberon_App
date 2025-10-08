import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { orderBy, orderWith } from '../types/orderBy.enum';
import { IsDate, IsEnum, IsNumber, IsUUID, ValidateIf } from 'class-validator';
import { FromShortUuid } from '../../common/decorators/fromshortuuid.decorator';
import { Transform, Type } from 'class-transformer';

export class GetAnswersQuery {
  @ApiProperty({ enum: orderWith })
  @IsEnum(orderWith, { message: 'Geçersiz sıralama türü' })
  order_with!: orderWith;
  @ApiProperty({ enum: orderBy })
  @IsEnum(orderBy, { message: 'Geçersiz sıralama' })
  order_by!: orderBy;

  @ValidateIf((o) => o.createdAt ?? o.count)
  @ApiPropertyOptional({ type: String, nullable: true })
  @IsUUID('all', { message: 'Geçersiz Id' })
  @FromShortUuid()
  key_id?: string;

  @ValidateIf((o) => o.key_id && o.order_with === orderWith.createdAt)
  @ApiPropertyOptional({ type: Date, nullable: true })
  @IsDate({ message: 'Geçersiz tarih' })
  @Type(() => Date)
  created_at?: Date;

  @ValidateIf(
    (o) =>
      o.key_id &&
      (o.order_with === orderWith.voteCount ||
        o.order_with === orderWith.commentCount),
  )
  @ApiPropertyOptional({ type: Number, nullable: true })
  @IsNumber({}, { message: 'Geçersiz sayı' })
  @Transform(({ value }) => (value ? parseInt(value, 10) : value))
  count?: number;
}

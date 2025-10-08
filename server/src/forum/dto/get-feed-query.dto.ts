import { ApiPropertyOptional } from '@nestjs/swagger';
import { orderBy, orderWithFeed } from '../types/orderBy.enum';
import {
  IsDate,
  IsEnum,
  IsNumber,
  IsOptional,
  IsUUID,
  Min,
  ValidateIf,
} from 'class-validator';
import { FromShortUuid } from '../../common/decorators/fromshortuuid.decorator';
import { Transform, Type } from 'class-transformer';

export class GetFeedQuery {
  @ApiPropertyOptional({
    enum: orderWithFeed,
    default: orderWithFeed.lastActivity,
  })
  @IsEnum(orderWithFeed)
  @Transform(({ value }) => value || orderWithFeed.lastActivity)
  order_with: orderWithFeed = orderWithFeed.lastActivity;

  @ApiPropertyOptional({
    enum: orderBy,
    default: orderBy.desc,
  })
  @IsEnum(orderBy)
  @Transform(({ value }) => value || orderBy.desc)
  order_by: orderBy = orderBy.desc;

  @ValidateIf((o) => o.date ?? o.count)
  @ApiPropertyOptional({ type: String, nullable: true })
  @IsUUID('all', { message: 'Geçersiz Id' })
  @FromShortUuid()
  key_id?: string;

  @ValidateIf(
    (o) =>
      o.key_id &&
      (o.order_with === orderWithFeed.createdAt ||
        o.order_with === orderWithFeed.lastActivity),
  )
  @ApiPropertyOptional({ type: Date, nullable: true })
  @IsDate({ message: 'Geçersiz tarih' })
  @Type(() => Date)
  date?: Date;

  @ValidateIf(
    (o) =>
      o.key_id &&
      (o.order_with === orderWithFeed.voteCount ||
        o.order_with === orderWithFeed.commentCount),
  )
  @ApiPropertyOptional({ type: Number, nullable: true })
  @IsNumber({}, { message: 'Geçersiz sayı' })
  @Transform(({ value }) => (value ? parseInt(value, 10) : value))
  count?: number;

  @ApiPropertyOptional({ type: Number, nullable: true })
  @IsOptional()
  @IsNumber({}, { message: 'Geçersiz sayı' })
  @Min(1, { message: 'Geçersiz sayı' })
  @Transform(({ value }) => (value ? parseInt(value, 10) : value))
  tag?: number;
}

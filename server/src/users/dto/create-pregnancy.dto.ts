import { ApiProperty } from '@nestjs/swagger';
import {
  ArrayNotEmpty,
  IsArray,
  IsBoolean,
  IsDate,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxDate,
  MinDate,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { IsNullable } from '../../common/decorators/nullable.decorator';
import { CreateFetusDto } from './create-fetus.dto';
import { deliveryType, pregnancyType } from '../../database/enums';

export class CreatePregnancyDto {
  @ApiProperty()
  @ValidateIf((o) => !o.lastPeriodDate || (o.lastPeriodDate && o.dueDate))
  @IsDate({ message: 'Tahmini doğum tarihi geçerli bir tarih olmalıdır.' })
  @MinDate(new Date(), {
    message: 'Tahmini doğum tarihi bugünden küçük olamaz.',
  })
  // max date should be 40 weeks from now
  @MaxDate(new Date(Date.now() + 1000 * 60 * 60 * 24 * 7 * 40), {
    message: 'Tahmini doğum tarihi en fazla 40 hafta sonrası olabilir.',
  })
  @Transform(({ value }) => (value ? new Date(value) : value))
  dueDate?: Date;

  @ApiProperty({ example: true })
  @IsBoolean({ message: 'Geçerli bir hamilelik durumu girilmelidir.' })
  birthGiven!: boolean;

  @ApiProperty()
  @MaxDate(new Date(), { message: 'Son adet tarihi bugünden büyük olamaz.' })
  // min date should be 40 weeks before now
  @MinDate(new Date(Date.now() - 1000 * 60 * 60 * 24 * 280), {
    message: 'Son adet tarihi en fazla 40 hafta öncesi olabilir.',
  })
  @ValidateIf((o) => !o.dueDate || (o.dueDate && o.lastPeriodDate))
  @IsDate({ message: 'Son adet tarihi geçerli bir tarih olmalıdır.' })
  @Transform(({ value }) => (value ? new Date(value) : value))
  lastPeriodDate?: Date;

  @ApiProperty()
  @IsOptional()
  @IsNullable()
  @IsString({ message: 'Notlar geçerli bir metin olmalıdır.' })
  @IsNotEmpty({ message: 'Notlar boş bırakılamaz.' })
  notes?: string;

  @ApiProperty({ enum: deliveryType })
  @IsOptional()
  @IsNullable()
  @IsEnum(deliveryType, {
    message: 'Geçerli bir doğum tipi girilmelidir.',
  })
  deliveryType?: deliveryType;

  @ApiProperty({ enum: pregnancyType })
  @IsEnum(pregnancyType, {
    message: 'Geçerli bir hamilelik tipi girilmelidir.',
  })
  type!: pregnancyType;

  @ApiProperty({ type: [CreateFetusDto] })
  @IsNotEmpty({ message: 'Bebek kısmı boş bırakılamaz' })
  @IsArray({ message: 'Geçerli bebek bilgisi girilmelidir.' })
  @ValidateNested({ each: true })
  @ArrayNotEmpty({ message: 'En az bir bebek bilgisi girilmelidir.' })
  @Type(() => CreateFetusDto)
  fetuses!: CreateFetusDto[];
}

import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsOptional, Min } from 'class-validator';

export class PaginationOptionsDto {
  constructor(order: 'asc' | 'desc', page: number) {
    this.order = order || 'asc';
    this.page = page || 1;
  }
  @ApiPropertyOptional({ enum: ['asc', 'desc'], default: 'asc' })
  @IsEnum(['asc', 'desc'], { message: 'Lütfen geçerli bir sıralama belirtin.' })
  @IsOptional()
  order!: 'asc' | 'desc';

  @ApiPropertyOptional({
    minimum: 1,
    default: 1,
  })
  @Type(() => Number)
  @IsInt({ message: 'Sayfa numarası tam sayı olmalıdır.' })
  @Min(1, { message: "Sayfa numarası 1'den büyük olmalıdır." })
  @IsOptional()
  page!: number;
}

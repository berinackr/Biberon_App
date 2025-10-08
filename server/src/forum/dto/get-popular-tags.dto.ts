import { Type } from 'class-transformer';
import { GeneralResponseDto } from '../../common/dto/general-response.dto';
import { PopularTag } from './popular-tag.dto';
import { ApiProperty } from '@nestjs/swagger';

export class GetPopularTagsDto extends GeneralResponseDto {
  constructor(data: GetPopularTagsDto) {
    super(data);
    this.data = data.data;
  }
  @ApiProperty({
    type: PopularTag,
    isArray: true,
  })
  @Type(() => PopularTag)
  data!: PopularTag[];
}

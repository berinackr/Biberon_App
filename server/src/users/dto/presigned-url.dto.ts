import { ApiProperty } from '@nestjs/swagger';

export class PresignedUrlDto {
  @ApiProperty()
  readonly url!: string;
}

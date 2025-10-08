import { ApiProperty } from '@nestjs/swagger';

export class PresignedPostDto {
  @ApiProperty()
  readonly url!: string;
  @ApiProperty({ additionalProperties: { type: 'string' } })
  readonly fields!: Map<string, string>;
}

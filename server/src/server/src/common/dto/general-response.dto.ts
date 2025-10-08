import { ApiProperty } from '@nestjs/swagger';

export class GeneralResponseDto {
  constructor(data: GeneralResponseDto) {
    this.message = data.message;
    this.status = data.status;
  }
  @ApiProperty()
  message!: string;
  @ApiProperty()
  status!: string;
}

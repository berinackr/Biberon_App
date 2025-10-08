import { ApiProperty } from '@nestjs/swagger';

export class ResponseErrorDto {
  @ApiProperty()
  message!: string;

  @ApiProperty({ example: 400 })
  statusCode!: number;

  @ApiProperty()
  error!: string;
}

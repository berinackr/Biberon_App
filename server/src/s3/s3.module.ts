import { Module } from '@nestjs/common';
import { S3Service } from './s3.service';
import { EnvModule } from '../env/env.module';

@Module({
  providers: [S3Service],
  exports: [S3Service],
  imports: [EnvModule],
})
export class S3Module {}

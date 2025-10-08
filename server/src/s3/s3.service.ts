import {
  S3Client,
  GetObjectCommand,
  HeadObjectCommand,
} from '@aws-sdk/client-s3';
import { Inject, Injectable } from '@nestjs/common';
import { EnvService } from '../env/env.service';
import Logger, { LoggerKey } from '../logging/types/logger.type';
import { createPresignedPost } from '@aws-sdk/s3-presigned-post';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

@Injectable()
export class S3Service {
  private readonly s3Client: S3Client;
  constructor(
    private envService: EnvService,
    @Inject(LoggerKey) private logger: Logger,
  ) {
    this.s3Client = new S3Client({
      region: this.envService.get('AWS_REGION'),
      credentials: {
        accessKeyId: this.envService.get('AWS_S3_ACCESS_KEY'),
        secretAccessKey: this.envService.get('AWS_S3_SECRET_ACCESS_KEY'),
      },
    });
  }

  async createPresignedPost(key: string) {
    this.logger.info('Creating presigned post');
    return await createPresignedPost(this.s3Client, {
      Bucket: this.envService.get('AWS_S3_BUCKET'),
      Expires: 60,
      Key: key,
      Conditions: [
        { bucket: this.envService.get('AWS_S3_BUCKET') },
        // content-type must be jpeg or png
        ['starts-with', '$Content-Type', 'image/'],
        ['content-length-range', 0, 1048576],
      ],
    });
  }

  async createPresignedUrl(key: string) {
    const command = new GetObjectCommand({
      Bucket: this.envService.get('AWS_S3_BUCKET'),
      Key: key,
    });
    return getSignedUrl(this.s3Client, command, { expiresIn: 3600 });
  }

  async checkFileExists(key: string) {
    const command = new HeadObjectCommand({
      Bucket: this.envService.get('AWS_S3_BUCKET'),
      Key: key,
    });
    try {
      await this.s3Client.send(command);
      return true;
    } catch (error) {
      return false;
    }
  }
}

import { Module } from '@nestjs/common';
import { ForumService } from './forum.service';
import { ForumController } from './forum.controller';
import { PostRepository } from './post.repository';

@Module({
  controllers: [ForumController],
  providers: [ForumService, PostRepository],
})
export class ForumModule {}

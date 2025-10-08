import {
  ForbiddenException,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import Logger, { LoggerKey } from '../logging/types/logger.type';
import { PostRepository } from './post.repository';
import { CreatePostDto } from './dto/create-post.dto';
import slugify from 'slugify';
import { CreatePostResponse } from './dto/create-post-response.dto';
import { GetPostQueryParamsDto } from './dto/get-post-query-params.dto';
import { PostDetailsWithEverything } from './dto/post-details.dto';
import { GeneralResponseDto } from '../common/dto/general-response.dto';
import { CreateAnswerDto } from './dto/create-answer.dto';
import { orderBy, orderWith, orderWithFeed } from './types/orderBy.enum';

@Injectable()
export class ForumService {
  constructor(
    @Inject(LoggerKey) private logger: Logger,
    private readonly postRepository: PostRepository,
  ) {}

  async createPost(data: CreatePostDto, userId: string) {
    this.logger.info('Creating post', {
      props: {
        userId,
        title: data.title,
      },
    });

    const slug = this.slugify(data.title);

    return new CreatePostResponse(
      await this.postRepository.createPost(data, slug, userId),
    );
  }

  async getPost(id: string, options: GetPostQueryParamsDto, userId?: string) {
    return new PostDetailsWithEverything(
      await this.postRepository.getPost(id, options, userId),
    );
  }

  async updatePost(id: string, data: CreatePostDto, userId: string) {
    this.logger.info('Updating post', {
      props: {
        userId,
        title: data.title,
      },
    });

    const slug = this.slugify(data.title);
    const post = await this.postRepository.checkPostExistsByUser(id, userId);
    if (!post) {
      throw new ForbiddenException();
    }

    return new CreatePostResponse(
      await this.postRepository.updatePost(id, data, slug),
    );
  }

  async votePost(postId: string, userId: string, voteTypeId: number) {
    await this.postRepository.votePost(postId, userId, voteTypeId);
    return new GeneralResponseDto({ message: 'Oy verildi', status: 'success' });
  }

  async deleteVote(postId: string, userId: string) {
    await this.postRepository.deleteVote(postId, userId);
    return new GeneralResponseDto({ message: 'Oy silindi', status: 'success' });
  }

  async createAnswer(data: CreateAnswerDto, postId: string, userId: string) {
    this.logger.info('Creating answer', {
      props: {
        userId,
        postId,
      },
    });
    const post = await this.postRepository.checkPostExists(postId);
    if (!post) {
      throw new NotFoundException();
    }
    return new CreatePostResponse(
      await this.postRepository.createAnswer(data, postId, userId),
    );
  }

  async updateAnswer(answerId: string, data: CreateAnswerDto, userId: string) {
    this.logger.info('Updating answer', {
      props: {
        userId,
        answerId,
      },
    });
    const answer = await this.postRepository.checkAnswerExistsByUser(
      answerId,
      userId,
    );
    if (!answer) {
      throw new ForbiddenException();
    }
    return new CreatePostResponse(
      await this.postRepository.updateAnswer(answerId, data),
    );
  }

  async createComment(data: CreateAnswerDto, postId: string, userId: string) {
    this.logger.info('Creating comment', {
      props: {
        userId,
        postId,
      },
    });
    const post = await this.postRepository.checkAnswerExists(postId);
    if (!post) {
      throw new NotFoundException();
    }
    return new CreatePostResponse(
      await this.postRepository.createComment(data, postId, userId),
    );
  }

  async updateComment(
    commentId: string,
    data: CreateAnswerDto,
    userId: string,
  ) {
    this.logger.info('Updating comment', {
      props: {
        userId,
        commentId,
      },
    });

    return new CreatePostResponse(
      await this.postRepository.updateComment(commentId, data, userId),
    );
  }

  async voteComment(commentId: string, userId: string, voteTypeId: number) {
    await this.postRepository.voteComment(commentId, userId, voteTypeId);
    return new GeneralResponseDto({ message: 'Oy verildi', status: 'success' });
  }

  async deleteCommentVote(commentId: string, userId: string) {
    await this.postRepository.deleteCommentVote(commentId, userId);
    return new GeneralResponseDto({ message: 'Oy silindi', status: 'success' });
  }

  async getPostsComments(
    postId: string,
    keys?: {
      createdAt: Date;
      id: string;
    },
    userId?: string,
  ) {
    return this.postRepository.getPostsComments(postId, keys, userId);
  }

  async getPostAnswers(
    postId: string,
    orderWith: orderWith,
    orderBy: orderBy,
    keys?: {
      id: string;
      createdAt?: Date;
      count?: number;
    },
    userId?: string,
  ) {
    return this.postRepository.getAnswers(
      postId,
      orderWith,
      orderBy,
      keys,
      userId,
    );
  }

  async getPopularTags() {
    return this.postRepository.getPopularTags();
  }

  async addBookmark(postId: string, userId: string) {
    await this.postRepository.addBookmark(postId, userId);
    return new GeneralResponseDto({
      message: 'Bookmark added',
      status: 'success',
    });
  }

  async removeBookmark(postId: string, userId: string) {
    await this.postRepository.removeBookmark(postId, userId);
    return new GeneralResponseDto({
      message: 'Bookmark removed',
      status: 'success',
    });
  }

  async getBookmarks(userId: string, keys?: { id: string; createdAt: Date }) {
    return this.postRepository.getBookmarks(userId, keys);
  }

  async setAnswerAsCorrect(postId: string, answerId: string, userId: string) {
    await this.postRepository.setSelectedAnswer(postId, answerId, userId);
    return new GeneralResponseDto({
      message: 'Answer set as correct',
      status: 'success',
    });
  }

  async getFeed(
    orderWith: orderWithFeed,
    orderBy: orderBy,
    keys?: {
      date?: Date;
      id?: string;
      count?: number;
    },
    tag?: number,
    userId?: string,
  ) {
    return this.postRepository.getFeed(orderWith, orderBy, keys, tag, userId);
  }

  slugify(title: string) {
    return (
      slugify(title, {
        locale: 'tr',
        lower: true,
      }) +
      '-' +
      new Date().getTime()
    );
  }
}

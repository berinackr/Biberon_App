import { GetCommentsQuery } from './dto/get-comments-query.dto';
import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ForumService } from './forum.service';
import {
  ApiCreatedResponse,
  ApiExtraModels,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiResponse,
  ApiTags,
  getSchemaPath,
} from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { Request } from 'express';
import { CreatePostDto } from './dto/create-post.dto';
import { CreatePostResponse } from './dto/create-post-response.dto';
import { Roles } from '../common/decorators/roles.decorator';
import { EmailVerifiedGuard } from '../common/guards/email-verifield.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { PostFindOneParams } from './params/post-find-one-params';
import { GetPostQueryParamsDto } from './dto/get-post-query-params.dto';
import { OptionalJwtAuthGuard } from '../common/guards/optional-auth.guard';
import {
  PostDetailsDto,
  PostDetailsWithComments,
  PostDetailsWithEverything,
  PostDetailsWithLikes,
  PostDetailsWithTags,
} from './dto/post-details.dto';
import { VoteQueryDto } from './dto/vote-query.dto';
import { GeneralResponseDto } from '../common/dto/general-response.dto';
import { CreateAnswerDto } from './dto/create-answer.dto';
import { UpdateAnswerParams } from './params/update-answer-params';
import { UpdateCommentParams } from './params/update-comment-params';
import { GetCommentDto } from './dto/get-comments.dto';
import { GetAnswersQuery } from './dto/get-answers-query.dto';
import { GetAnswersDto } from './dto/get-answers.dto';
import { GetPopularTagsDto } from './dto/get-popular-tags.dto';
import { BookmarkedPosts } from './dto/bookmarked-posts.dto';
import { GetFeedQuery } from './dto/get-feed-query.dto';
import { PostFeed } from './dto/post-feed.dto';

@ApiTags('Forum')
@Controller({
  path: 'forum',
  version: '1',
})
@Controller('forum')
export class ForumController {
  constructor(private readonly forumService: ForumService) {}

  @Roles('USER')
  @Post('/post')
  @ApiOperation({ summary: 'Create post' })
  @ApiCreatedResponse({ description: 'Post created', type: CreatePostResponse })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  createPost(@Req() req: Request, @Body() data: CreatePostDto) {
    return this.forumService.createPost(data, req.user.id);
  }

  @Get('/feed')
  @ApiOperation({
    summary:
      'Get feed. tags query for get feed for specific tag. key_id must have on pagination. for date based sorting date must be specified on pagination. For vote or comment based sorting count must be specified. Both date, key_id and count must be the latest fetched post properties one that you want to fetch after that post',
  })
  @ApiOkResponse({ description: 'Feed', type: PostFeed })
  @UseGuards(OptionalJwtAuthGuard)
  async getFeed(@Query() query: GetFeedQuery, @Req() req: Request) {
    return new PostFeed({
      data: await this.forumService.getFeed(
        query.order_with,
        query.order_by,
        {
          id: query.key_id,
          date: query.date,
          count: query.count,
        },
        query.tag,
        req.user.id,
      ),
      message: 'Feed fetched',
      status: 'success',
    });
  }

  @ApiParam({ name: 'id', type: 'string' })
  @Get('/post/:id')
  @ApiResponse({
    status: 200,
    content: {
      'application/json': {
        schema: {
          oneOf: [
            { $ref: getSchemaPath(PostDetailsDto) },
            { $ref: getSchemaPath(PostDetailsWithTags) },
          ],
        },
      },
      'application/json-withtags': {
        schema: {
          $ref: getSchemaPath(PostDetailsWithTags),
          description: 'Post with tags',
        },
      },
      'application/json-withlikes': {
        schema: {
          $ref: getSchemaPath(PostDetailsWithLikes),
          description: 'Post with likes',
        },
      },
      'application/json-withcomments': {
        schema: {
          $ref: getSchemaPath(PostDetailsWithComments),
          description: 'Post with tags and likes',
        },
      },
      'application/json-witheverything': {
        schema: {
          $ref: getSchemaPath(PostDetailsWithEverything),
          description: 'Post with tags, likes and comments',
        },
      },
    },
  })
  @ApiExtraModels(
    PostDetailsDto,
    PostDetailsWithTags,
    PostDetailsWithLikes,
    PostDetailsWithComments,
    PostDetailsWithEverything,
  )
  @UseGuards(OptionalJwtAuthGuard)
  getPost(
    @Param() params: PostFindOneParams,
    @Query() query: GetPostQueryParamsDto,
    @Req() req: Request,
  ) {
    return this.forumService.getPost(params.id, query, req.user && req.user.id);
  }

  @Get('/tags/popular')
  @ApiOkResponse({ description: 'Popular tags', type: GetPopularTagsDto })
  async getPopularTags() {
    const data = await this.forumService.getPopularTags();
    return new GetPopularTagsDto({
      data,
      message: 'Popular tags fetched',
      status: 'success',
    });
  }

  @Get('/bookmarks')
  @Roles('USER')
  @ApiOkResponse({ description: 'Bookmarks', type: BookmarkedPosts })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  async getBookmarks(@Req() req: Request, @Query() query: GetCommentsQuery) {
    const keys =
      query.createdAt && query.keyId
        ? {
            id: query.keyId,
            createdAt: query.createdAt,
          }
        : undefined;
    const data = await this.forumService.getBookmarks(req.user.id, keys);

    return new BookmarkedPosts({
      data,
      message: 'Bookmarks fetched',
      status: 'success',
    });
  }

  @Put('/post/:id')
  @ApiParam({ name: 'id', type: 'string' })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  updatePost(
    @Param() params: PostFindOneParams,
    @Body() data: CreatePostDto,
    @Req() req: Request,
  ) {
    return this.forumService.updatePost(params.id, data, req.user.id);
  }

  @Put('/post/:id/votes')
  @ApiOkResponse({ description: 'Post voted', type: GeneralResponseDto })
  @ApiParam({ name: 'id', type: 'string' })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  votePost(
    @Param() params: PostFindOneParams,
    @Query() query: VoteQueryDto,
    @Req() req: Request,
  ) {
    return this.forumService.votePost(
      params.id,
      req.user.id,
      query.vote_type_id,
    );
  }

  @Post('/post/:id/bookmark')
  @ApiParam({ name: 'id', type: 'string' })
  @Roles('USER')
  @ApiCreatedResponse({
    description: 'Post bookmarked',
    type: GeneralResponseDto,
  })
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  bookmarkPost(@Param() params: PostFindOneParams, @Req() req: Request) {
    return this.forumService.addBookmark(params.id, req.user.id);
  }

  @Delete('/post/:id/bookmark')
  @ApiParam({ name: 'id', type: 'string' })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @ApiResponse({ status: 200, type: GeneralResponseDto })
  deleteBookmarkPost(@Param() params: PostFindOneParams, @Req() req: Request) {
    return this.forumService.removeBookmark(params.id, req.user.id);
  }

  @Delete('/post/:id/votes')
  @ApiOkResponse({ description: 'Post vote deleted', type: GeneralResponseDto })
  @ApiParam({ name: 'id', type: 'string' })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  deleteVotePost(@Param() params: PostFindOneParams, @Req() req: Request) {
    return this.forumService.deleteVote(params.id, req.user.id);
  }

  @Post('/post/:id/answer')
  @ApiParam({ name: 'id', type: 'string' })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  @ApiCreatedResponse({
    description: 'Answer created',
    type: CreatePostResponse,
  })
  createAnswer(
    @Param() params: PostFindOneParams,
    @Req() req: Request,
    @Body() data: CreateAnswerDto,
  ) {
    return this.forumService.createAnswer(data, params.id, req.user.id);
  }

  @Get('/post/:id/answer')
  @ApiParam({ name: 'id', type: 'string' })
  @Roles('USER')
  @UseGuards(OptionalJwtAuthGuard)
  @ApiOkResponse({ description: 'Answers', type: GetAnswersDto })
  async getAnswers(
    @Param() params: PostFindOneParams,
    @Query() query: GetAnswersQuery,
    @Req() req: Request,
  ) {
    const keys = query.key_id
      ? query.created_at
        ? { id: query.key_id, createdAt: query.created_at! }
        : { id: query.key_id, count: query.count! }
      : undefined;

    const data = await this.forumService.getPostAnswers(
      params.id,
      query.order_with,
      query.order_by,
      keys,
      req.user.id,
    );

    return new GetAnswersDto({
      data,
      message: 'Answers fetched',
      status: 'success',
    });
  }

  @Put('/post/:id/answer/:answerId')
  @ApiParam({ name: 'id', type: 'string' })
  @ApiParam({ name: 'answerId', type: 'string' })
  @ApiOkResponse({ description: 'Answer updated', type: CreatePostResponse })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  updateAnswer(
    @Param() params: UpdateAnswerParams,
    @Req() req: Request,
    @Body() data: CreateAnswerDto,
  ) {
    return this.forumService.updateAnswer(params.answerId, data, req.user.id);
  }

  @Post('/post/:id/answer/:answerId/correct')
  @ApiParam({ name: 'id', type: 'string' })
  @ApiParam({ name: 'answerId', type: 'string' })
  @ApiCreatedResponse({
    description: 'Answer set as correct',
    type: GeneralResponseDto,
  })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  setAnswerAsCorrect(@Param() params: UpdateAnswerParams, @Req() req: Request) {
    return this.forumService.setAnswerAsCorrect(
      params.id,
      params.answerId,
      req.user.id,
    );
  }

  @Post('/post/:id/comment')
  @ApiParam({ name: 'id', type: 'string' })
  @ApiCreatedResponse({
    description: 'Comment created',
    type: CreatePostResponse,
  })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  createComment(
    @Param() params: PostFindOneParams,
    @Req() req: Request,
    @Body() data: CreateAnswerDto,
  ) {
    return this.forumService.createComment(data, params.id, req.user.id);
  }

  @Get('/post/:id/comment')
  @ApiParam({ name: 'id', type: 'string' })
  @ApiOkResponse({ description: 'Comments', type: GetCommentDto })
  @Roles('USER')
  @UseGuards(OptionalJwtAuthGuard)
  async getComments(
    @Param() params: PostFindOneParams,
    @Query() query: GetCommentsQuery,
    @Req() req: Request,
  ) {
    const keys =
      query.createdAt && query.keyId
        ? {
            id: query.keyId,
            createdAt: query.createdAt,
          }
        : undefined;
    const data = await this.forumService.getPostsComments(
      params.id,
      keys,
      req.user.id,
    );
    return new GetCommentDto({
      data,
      message: 'Comments fetched',
      status: 'success',
    });
  }

  @Put('/post/:id/comment/:commentId')
  @ApiParam({ name: 'id', type: 'string' })
  @ApiParam({ name: 'commentId', type: 'string' })
  @ApiOkResponse({ description: 'Comment updated', type: CreatePostResponse })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  updateComment(
    @Param() params: UpdateCommentParams,
    @Req() req: Request,
    @Body() data: CreateAnswerDto,
  ) {
    return this.forumService.updateComment(params.commentId, data, req.user.id);
  }

  @Post('/post/:id/comment/:commentId/votes')
  @ApiParam({ name: 'id', type: 'string' })
  @ApiParam({ name: 'commentId', type: 'string' })
  @ApiOkResponse({ description: 'Comment voted', type: GeneralResponseDto })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  voteComment(
    @Param() params: UpdateCommentParams,
    @Query() query: VoteQueryDto,
    @Req() req: Request,
  ) {
    return this.forumService.voteComment(
      params.commentId,
      req.user.id,
      query.vote_type_id,
    );
  }

  @Delete('/post/:id/comment/:commentId/votes')
  @ApiParam({ name: 'id', type: 'string' })
  @ApiParam({ name: 'commentId', type: 'string' })
  @ApiOkResponse({
    description: 'Comment vote deleted',
    type: GeneralResponseDto,
  })
  @Roles('USER')
  @UseGuards(AuthGuard('jwt'), EmailVerifiedGuard, RolesGuard)
  deleteVoteComment(@Param() params: UpdateCommentParams, @Req() req: Request) {
    return this.forumService.deleteCommentVote(params.commentId, req.user.id);
  }
}

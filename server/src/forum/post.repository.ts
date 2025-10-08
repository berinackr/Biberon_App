import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectKysely } from 'nestjs-kysely';
import { Database } from '../database/database';
import { CreatePostDto } from './dto/create-post.dto';
import { GetPostQueryParamsDto } from './dto/get-post-query-params.dto';
import {
  jsonArrayFrom,
  jsonBuildObject,
  jsonObjectFrom,
} from 'kysely/helpers/postgres';
import { NotNull } from 'kysely';
import { CreateAnswerDto } from './dto/create-answer.dto';
import { orderBy, orderWith, orderWithFeed } from './types/orderBy.enum';
import { QuillDelta } from '../utils/types/delta-quill.type';
import { json } from '../database/extensions/json';
import { getTextsFromDelta } from '../utils/rich-text/get-texts-from-delta';

@Injectable()
export class PostRepository {
  constructor(@InjectKysely() private readonly db: Database) {}

  async createPost(data: CreatePostDto, slug: string, userId: string) {
    return await this.db
      .with('new_post', (db) =>
        db
          .insertInto('post')
          .values({
            body: getTextsFromDelta(data.richText),
            richText: json(data.richText),
            title: data.title,
            slug,
            userId,
          })
          .returning('id'),
      )
      .with('new_post_tag', (db) =>
        db
          .insertInto('postTag')
          .values((eb) => {
            return data.tags.map((tag) => ({
              postId: eb.selectFrom('new_post').select('id'),
              tagId: tag,
            }));
          })
          .returningAll(),
      )
      .selectFrom('new_post')
      .selectAll('new_post')
      .executeTakeFirstOrThrow();
  }

  async getPost(id: string, options: GetPostQueryParamsDto, userId?: string) {
    const result = await this.db
      .selectFrom('post as a')
      .leftJoin('user', 'user.id', 'a.userId')
      .select([
        'a.id',
        'a.title',
        'a.body',
        'a.richText',
        'a.createdAt',
        'a.lastActivityDate',
        'a.slug',
        'a.updatedAt',
        'a.postTypeId',
      ])
      .select(({ ref, eb }) => [
        eb
          .case()
          .when('user.id', 'is not', null)
          .then(
            jsonBuildObject({
              id: ref('user.id').$notNull(),
              username: ref('user.username').$notNull(),
              avatarPath: ref('user.avatarPath'),
            }),
          )
          .end()
          .as('user'),
        eb
          .selectFrom('post')
          .select((eb) =>
            eb.fn.countAll().$castTo<string>().$notNull().as('count'),
          )
          .where('parentId', '=', id)
          .as('totalAnswerCount'),

        eb
          .case()
          .when('a.selectedAnswerId', 'is not', null)
          .then(true)
          .else(false)
          .end()
          .as('isAnswered'),
      ])
      .$if(options.tags, (db) =>
        db.select((eb) =>
          jsonArrayFrom(
            eb
              .selectFrom('tag')
              .select(['tag.id', 'tag.name'])
              .whereRef(
                'tag.id',
                'in',
                eb
                  .selectFrom('postTag')
                  .select('tagId')
                  .where('postId', '=', id),
              ),
          ).as('tags'),
        ),
      )
      .$if(options.likes, (db) =>
        db.select((eb) => [
          eb
            .selectFrom('postVote')
            .where('postVote.postId', '=', id)
            .where('postVote.voteTypeId', '!=', 2)
            .select(
              eb.fn.countAll().$castTo<string>().$notNull().as('likeCount'),
            )
            .as('totalVote'),

          eb
            .selectFrom('postVote')
            .where('postVote.postId', '=', id)
            .where('postVote.voteTypeId', '=', 1)
            .select(
              eb.fn.countAll().$castTo<string>().$notNull().as('likeCount'),
            )
            .as('totalLike'),

          eb
            .selectFrom('postVote')
            .where('postVote.postId', '=', id)
            .where('postVote.voteTypeId', '=', 3)
            .select(
              eb.fn.countAll().$castTo<string>().$notNull().as('likeCount'),
            )
            .as('totalSmiley'),

          eb
            .selectFrom('postVote')
            .where('postVote.postId', '=', id)
            .where('postVote.voteTypeId', '=', 4)
            .select(
              eb.fn.countAll().$castTo<string>().$notNull().as('likeCount'),
            )
            .as('totalClap'),

          eb
            .selectFrom('postVote')
            .where('postVote.postId', '=', id)
            .where('postVote.voteTypeId', '=', 5)
            .select(
              eb.fn.countAll().$castTo<string>().$notNull().as('likeCount'),
            )
            .as('totalHeart'),
        ]),
      )
      .$if(!!userId, (db) =>
        db.select((eb) => [
          eb
            .selectFrom('postVote')
            .where('postId', '=', id)
            .where('userId', '=', userId!)
            .select('voteTypeId')
            .as('userVote'),

          eb
            .exists((eb) =>
              eb
                .selectFrom('bookmarkedPost')
                .where('postId', '=', id)
                .where('userId', '=', userId!),
            )
            .as('bookmarked'),
        ]),
      )
      .$if(options.comments, (db) =>
        db.select((eb) => [
          jsonArrayFrom(
            eb
              .selectFrom('post as p')
              .innerJoin('user as u', 'u.id', 'p.userId')
              .where('p.parentId', '=', id)
              .where((eb) =>
                eb(eb.ref('a.selectedAnswerId'), 'is', null).or(
                  'p.id',
                  '!=',
                  eb.ref('a.selectedAnswerId'),
                ),
              )
              .select([
                'p.id',
                'p.body',
                'p.richText',
                'p.createdAt',
                'p.updatedAt',
                'p.lastActivityDate',
                'p.postTypeId',
                'p.parentId',
              ])
              .select(({ ref, eb }) => [
                eb
                  .case()
                  .when('u.id', 'is not', null)
                  .then(
                    jsonBuildObject({
                      id: ref('u.id').$notNull(),
                      username: ref('u.username').$notNull(),
                      avatarPath: ref('u.avatarPath'),
                    }),
                  )
                  .end()
                  .as('user'),

                eb
                  .selectFrom('postVote')
                  .whereRef('postVote.postId', '=', ref('p.id'))
                  .where('postVote.voteTypeId', '!=', 2)
                  .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                  .as('totalVote'),

                eb
                  .selectFrom('postVote')
                  .whereRef('postVote.postId', '=', ref('p.id'))
                  .where('postVote.voteTypeId', '=', 1)
                  .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                  .as('totalLike'),

                eb
                  .selectFrom('postVote')
                  .whereRef('postVote.postId', '=', ref('p.id'))
                  .where('postVote.voteTypeId', '=', 3)
                  .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                  .as('totalSmiley'),

                eb
                  .selectFrom('postVote')
                  .whereRef('postVote.postId', '=', ref('p.id'))
                  .where('postVote.voteTypeId', '=', 4)
                  .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                  .as('totalClap'),

                eb
                  .selectFrom('postVote')
                  .whereRef('postVote.postId', '=', ref('p.id'))
                  .where('postVote.voteTypeId', '=', 5)
                  .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                  .as('totalHeart'),

                eb
                  .selectFrom('comment')
                  .select((eb) =>
                    eb.fn.countAll().$castTo<string>().as('count'),
                  )
                  .whereRef('comment.postId', '=', ref('p.id'))
                  .as('totalCommentCount'),

                jsonArrayFrom(
                  eb
                    .selectFrom('comment as c')
                    .select([
                      'c.id',
                      'c.body',
                      'c.richText',
                      'c.createdAt',
                      'c.updatedAt',
                      'c.postId',
                    ])
                    .innerJoin('user as u', 'u.id', 'c.userId')
                    .whereRef('c.postId', '=', ref('p.id'))
                    .select(({ eb, ref }) => [
                      eb
                        .case()
                        .when('u.id', 'is not', null)
                        .then(
                          jsonBuildObject({
                            id: eb.ref('u.id').$notNull(),
                            username: eb.ref('u.username').$notNull(),
                            avatarPath: eb.ref('u.avatarPath'),
                          }),
                        )
                        .end()
                        .as('user'),

                      eb
                        .selectFrom('commentVote')
                        .whereRef('commentId', '=', ref('c.id'))
                        .where('commentVote.voteTypeId', '!=', 2)
                        .select(
                          eb.fn.countAll().$castTo<string>().as('likeCount'),
                        )
                        .as('totalVote'),

                      eb
                        .selectFrom('commentVote')
                        .whereRef('commentId', '=', ref('c.id'))
                        .where('commentVote.voteTypeId', '=', 1)
                        .select(
                          eb.fn.countAll().$castTo<string>().as('likeCount'),
                        )
                        .as('totalLike'),

                      eb
                        .selectFrom('commentVote')
                        .whereRef('commentId', '=', ref('c.id'))
                        .where('commentVote.voteTypeId', '=', 3)
                        .select(
                          eb.fn.countAll().$castTo<string>().as('likeCount'),
                        )
                        .as('totalSmiley'),

                      eb
                        .selectFrom('commentVote')
                        .whereRef('commentId', '=', ref('c.id'))
                        .where('commentVote.voteTypeId', '=', 4)
                        .select(
                          eb.fn.countAll().$castTo<string>().as('likeCount'),
                        )
                        .as('totalClap'),

                      eb
                        .selectFrom('commentVote')
                        .whereRef('commentId', '=', ref('c.id'))
                        .where('commentVote.voteTypeId', '=', 5)
                        .select(
                          eb.fn.countAll().$castTo<string>().as('likeCount'),
                        )
                        .as('totalHeart'),
                    ])
                    .$if(!!userId, (db) =>
                      db.select(({ eb, ref }) =>
                        eb
                          .selectFrom('commentVote')
                          .whereRef('commentId', '=', ref('c.id'))
                          .where('userId', '=', userId!)
                          .select('voteTypeId')
                          .as('userVote'),
                      ),
                    )
                    .$narrowType<{
                      totalVote: NotNull;
                      totalLike: NotNull;
                      totalSmiley: NotNull;
                      totalClap: NotNull;
                      totalHeart: NotNull;
                      richText: QuillDelta;
                    }>()
                    .orderBy('c.createdAt', 'asc')
                    .limit(5),
                ).as('comments'),
              ])
              .$if(!!userId, (db) =>
                db.select(({ eb, ref }) =>
                  eb
                    .selectFrom('postVote')
                    .whereRef('postId', '=', ref('p.id'))
                    .where('userId', '=', userId!)
                    .select('voteTypeId')
                    .as('userVote'),
                ),
              )
              .$narrowType<{
                totalCommentCount: NotNull;
                totalVote: NotNull;
                totalLike: NotNull;
                totalSmiley: NotNull;
                totalClap: NotNull;
                totalHeart: NotNull;
                parentId: NotNull;
                richText: QuillDelta;
              }>()
              .orderBy('p.createdAt', 'asc')
              .limit(10),
          ).as('answers'),

          eb
            .case()
            .when('a.selectedAnswerId', 'is not', null)
            .then(
              jsonObjectFrom(
                eb
                  .selectFrom('post as s')
                  .innerJoin('user as u', 'u.id', 's.userId')
                  .select([
                    's.id',
                    's.body',
                    's.richText',
                    's.createdAt',
                    's.updatedAt',
                    's.postTypeId',
                    's.parentId',
                  ])
                  .select(({ ref, eb }) => [
                    eb
                      .case()
                      .when('u.id', 'is not', null)
                      .then(
                        jsonBuildObject({
                          id: ref('u.id').$notNull(),
                          username: ref('u.username').$notNull(),
                          avatarPath: ref('u.avatarPath'),
                        }),
                      )
                      .end()
                      .as('user'),

                    eb
                      .selectFrom('postVote')
                      .whereRef('postVote.postId', '=', ref('s.id'))
                      .where('postVote.voteTypeId', '!=', 2)
                      .select(
                        eb.fn.countAll().$castTo<string>().as('likeCount'),
                      )
                      .as('totalVote'),

                    eb
                      .selectFrom('postVote')
                      .whereRef('postVote.postId', '=', ref('s.id'))
                      .where('postVote.voteTypeId', '=', 1)
                      .select(
                        eb.fn.countAll().$castTo<string>().as('likeCount'),
                      )
                      .as('totalLike'),

                    eb
                      .selectFrom('postVote')
                      .whereRef('postVote.postId', '=', ref('s.id'))
                      .where('postVote.voteTypeId', '=', 3)
                      .select(
                        eb.fn.countAll().$castTo<string>().as('likeCount'),
                      )
                      .as('totalSmiley'),

                    eb
                      .selectFrom('postVote')
                      .whereRef('postVote.postId', '=', ref('s.id'))
                      .where('postVote.voteTypeId', '=', 4)
                      .select(
                        eb.fn.countAll().$castTo<string>().as('likeCount'),
                      )
                      .as('totalClap'),

                    eb
                      .selectFrom('postVote')
                      .whereRef('postVote.postId', '=', ref('s.id'))
                      .where('postVote.voteTypeId', '=', 5)
                      .select(
                        eb.fn.countAll().$castTo<string>().as('likeCount'),
                      )
                      .as('totalHeart'),

                    eb
                      .selectFrom('comment')
                      .select((eb) =>
                        eb.fn.countAll().$castTo<string>().as('count'),
                      )
                      .whereRef('comment.postId', '=', ref('s.id'))
                      .as('totalCommentCount'),

                    jsonArrayFrom(
                      eb
                        .selectFrom('comment as c')
                        .select([
                          'c.id',
                          'c.body',
                          'c.richText',
                          'c.createdAt',
                          'c.updatedAt',
                          'c.postId',
                        ])
                        .innerJoin('user as u', 'u.id', 'c.userId')
                        .whereRef('c.postId', '=', ref('s.id'))
                        .select(({ eb, ref }) => [
                          eb
                            .case()
                            .when('u.id', 'is not', null)
                            .then(
                              jsonBuildObject({
                                id: eb.ref('u.id').$notNull(),
                                username: eb.ref('u.username').$notNull(),
                                avatarPath: eb.ref('u.avatarPath'),
                              }),
                            )
                            .end()
                            .as('user'),

                          eb
                            .selectFrom('commentVote')
                            .whereRef('commentId', '=', ref('c.id'))
                            .where('commentVote.voteTypeId', '!=', 2)
                            .select(
                              eb.fn
                                .countAll()
                                .$castTo<string>()
                                .as('likeCount'),
                            )
                            .as('totalVote'),

                          eb
                            .selectFrom('commentVote')
                            .whereRef('commentId', '=', ref('c.id'))
                            .where('commentVote.voteTypeId', '=', 1)
                            .select(
                              eb.fn
                                .countAll()
                                .$castTo<string>()
                                .as('likeCount'),
                            )
                            .as('totalLike'),

                          eb
                            .selectFrom('commentVote')
                            .whereRef('commentId', '=', ref('c.id'))
                            .where('commentVote.voteTypeId', '=', 3)
                            .select(
                              eb.fn
                                .countAll()
                                .$castTo<string>()
                                .as('likeCount'),
                            )
                            .as('totalSmiley'),

                          eb
                            .selectFrom('commentVote')
                            .whereRef('commentId', '=', ref('c.id'))
                            .where('commentVote.voteTypeId', '=', 4)
                            .select(
                              eb.fn
                                .countAll()
                                .$castTo<string>()
                                .as('likeCount'),
                            )
                            .as('totalClap'),

                          eb
                            .selectFrom('commentVote')
                            .whereRef('commentId', '=', ref('c.id'))
                            .where('commentVote.voteTypeId', '=', 5)
                            .select(
                              eb.fn
                                .countAll()
                                .$castTo<string>()
                                .as('likeCount'),
                            )
                            .as('totalHeart'),
                        ])
                        .$if(!!userId, (db) =>
                          db.select(({ eb, ref }) =>
                            eb
                              .selectFrom('commentVote')
                              .whereRef('commentId', '=', ref('c.id'))
                              .where('userId', '=', userId!)
                              .select('voteTypeId')
                              .as('userVote'),
                          ),
                        )
                        .$narrowType<{
                          totalVote: NotNull;
                          totalLike: NotNull;
                          totalSmiley: NotNull;
                          totalClap: NotNull;
                          totalHeart: NotNull;
                          richText: QuillDelta;
                        }>()
                        .orderBy('c.createdAt', 'asc')
                        .limit(5),
                    ).as('comments'),
                  ])
                  .$if(!!userId, (db) =>
                    db.select(({ eb, ref }) =>
                      eb
                        .selectFrom('postVote')
                        .whereRef('postId', '=', ref('s.id'))
                        .where('userId', '=', userId!)
                        .select('voteTypeId')
                        .as('userVote'),
                    ),
                  )
                  .$narrowType<{
                    totalVote: NotNull;
                    totalLike: NotNull;
                    totalSmiley: NotNull;
                    totalClap: NotNull;
                    totalHeart: NotNull;
                    parentId: NotNull;
                    totalCommentCount: NotNull;
                    richText: QuillDelta;
                  }>()
                  .whereRef('s.id', '=', eb.ref('a.selectedAnswerId')),
              ),
            )
            .else(null)
            .end()
            .as('selectedAnswer'),
        ]),
      )
      .where('a.id', '=', id)
      .where('a.postTypeId', '=', 1)
      .$narrowType<{
        title: NotNull;
        slug: NotNull;
        totalAnswerCount: NotNull;
        totalVote: NotNull;
        totalLike: NotNull;
        totalSmiley: NotNull;
        totalClap: NotNull;
        totalHeart: NotNull;
        richText: QuillDelta;
      }>()
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Gönderi bulunamadı'),
      );
    console.dir(Array.isArray(result.body), { depth: null });
    return result;
  }

  async getPostsComments(
    postId: string,
    keys?: {
      createdAt: Date;
      id: string;
    },
    userId?: string,
  ) {
    return await this.db
      .selectFrom('comment')
      .where('comment.postId', '=', postId)
      .innerJoin('user', 'user.id', 'comment.userId')
      .select([
        'comment.id',
        'comment.body',
        'comment.richText',
        'comment.createdAt',
        'comment.updatedAt',
        'comment.postId',
      ])
      .select(({ ref, eb }) => [
        eb
          .case()
          .when('user.id', 'is not', null)
          .then(
            jsonBuildObject({
              id: ref('user.id').$notNull(),
              username: ref('user.username').$notNull(),
              avatarPath: ref('user.avatarPath'),
            }),
          )
          .end()
          .as('user'),
        eb
          .selectFrom('commentVote')
          .whereRef('commentVote.commentId', '=', ref('comment.id'))
          .where('commentVote.voteTypeId', '!=', 2)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalVote'),

        eb
          .selectFrom('commentVote')
          .whereRef('commentVote.commentId', '=', ref('comment.id'))
          .where('commentVote.voteTypeId', '=', 1)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalLike'),

        eb
          .selectFrom('commentVote')
          .whereRef('commentVote.commentId', '=', ref('comment.id'))
          .where('commentVote.voteTypeId', '=', 3)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalSmiley'),

        eb
          .selectFrom('commentVote')
          .whereRef('commentVote.commentId', '=', ref('comment.id'))
          .where('commentVote.voteTypeId', '=', 4)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalClap'),

        eb
          .selectFrom('commentVote')
          .whereRef('commentVote.commentId', '=', ref('comment.id'))
          .where('commentVote.voteTypeId', '=', 5)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalHeart'),
      ])
      .$if(!!userId, (db) =>
        db.select(({ eb, ref }) =>
          eb
            .selectFrom('commentVote')
            .whereRef('commentId', '=', ref('comment.id'))
            .where('userId', '=', userId!)
            .select('voteTypeId')
            .as('userVote'),
        ),
      )
      .orderBy('comment.createdAt', 'asc')
      .orderBy('comment.id', 'asc')
      .$if(!!keys, (db) =>
        db.where((eb) =>
          eb('comment.createdAt', '>=', keys!.createdAt).and(
            eb('comment.createdAt', '>', keys!.createdAt).or(
              'comment.id',
              '>',
              keys!.id,
            ),
          ),
        ),
      )
      .$narrowType<{
        totalVote: NotNull;
        totalLike: NotNull;
        totalSmiley: NotNull;
        totalClap: NotNull;
        totalHeart: NotNull;
        richText: QuillDelta;
      }>()
      .limit(5)
      .execute();
  }

  async getAnswers(
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
    return await this.db
      .selectFrom('post')
      .where('parentId', '=', postId)
      .where('post.postTypeId', '=', 2)
      .innerJoin('user', 'user.id', 'post.userId')
      .select([
        'post.id',
        'post.body',
        'post.richText',
        'post.createdAt',
        'post.updatedAt',
        'post.postTypeId',
        'post.parentId',
      ])
      .select(({ ref, eb }) => [
        eb
          .case()
          .when('user.id', 'is not', null)
          .then(
            jsonBuildObject({
              id: ref('user.id').$notNull(),
              username: ref('user.username').$notNull(),
              avatarPath: ref('user.avatarPath'),
            }),
          )
          .end()
          .as('user'),

        eb
          .selectFrom('postVote')
          .whereRef('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '!=', 2)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalVote'),

        eb
          .selectFrom('postVote')
          .whereRef('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 1)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalLike'),

        eb
          .selectFrom('postVote')
          .whereRef('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 3)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalSmiley'),

        eb
          .selectFrom('postVote')
          .whereRef('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 4)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalClap'),

        eb
          .selectFrom('postVote')
          .whereRef('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 5)
          .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
          .as('totalHeart'),

        eb
          .selectFrom('comment')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('count'))
          .whereRef('comment.postId', '=', ref('post.id'))
          .as('totalCommentCount'),

        jsonArrayFrom(
          eb
            .selectFrom('comment as c')
            .select([
              'c.id',
              'c.body',
              'c.richText',
              'c.createdAt',
              'c.updatedAt',
              'c.postId',
            ])
            .innerJoin('user as u', 'u.id', 'c.userId')
            .whereRef('c.postId', '=', ref('post.id'))
            .select(({ eb, ref }) => [
              eb
                .case()
                .when('u.id', 'is not', null)
                .then(
                  jsonBuildObject({
                    id: eb.ref('u.id').$notNull(),
                    username: eb.ref('u.username').$notNull(),
                    avatarPath: eb.ref('u.avatarPath'),
                  }),
                )
                .end()
                .as('user'),

              eb
                .selectFrom('commentVote')
                .whereRef('commentId', '=', ref('c.id'))
                .where('commentVote.voteTypeId', '!=', 2)
                .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                .as('totalVote'),

              eb
                .selectFrom('commentVote')
                .whereRef('commentId', '=', ref('c.id'))
                .where('commentVote.voteTypeId', '=', 1)
                .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                .as('totalLike'),

              eb
                .selectFrom('commentVote')
                .whereRef('commentId', '=', ref('c.id'))
                .where('commentVote.voteTypeId', '=', 3)
                .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                .as('totalSmiley'),

              eb
                .selectFrom('commentVote')
                .whereRef('commentId', '=', ref('c.id'))
                .where('commentVote.voteTypeId', '=', 4)
                .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                .as('totalClap'),

              eb
                .selectFrom('commentVote')
                .whereRef('commentId', '=', ref('c.id'))
                .where('commentVote.voteTypeId', '=', 5)
                .select(eb.fn.countAll().$castTo<string>().as('likeCount'))
                .as('totalHeart'),
            ])
            .$if(!!userId, (db) =>
              db.select(({ eb, ref }) =>
                eb
                  .selectFrom('commentVote')
                  .whereRef('commentId', '=', ref('c.id'))
                  .where('userId', '=', userId!)
                  .select('voteTypeId')
                  .as('userVote'),
              ),
            )
            .$narrowType<{
              totalVote: NotNull;
              totalLike: NotNull;
              totalSmiley: NotNull;
              totalClap: NotNull;
              totalHeart: NotNull;
              richText: QuillDelta;
            }>()
            .orderBy('c.createdAt', 'asc')
            .limit(5),
        ).as('comments'),
      ])
      .$if(!!userId, (db) =>
        db.select(({ eb, ref }) =>
          eb
            .selectFrom('postVote')
            .whereRef('postId', '=', ref('post.id'))
            .where('userId', '=', userId!)
            .select('voteTypeId')
            .as('userVote'),
        ),
      )
      .$if(orderWith === 'createdAt', (db) =>
        db.orderBy('post.createdAt', orderBy).orderBy('post.id', orderBy),
      )
      .$if(orderWith === 'voteCount', (db) =>
        db.orderBy('totalVote', orderBy).orderBy('post.id', orderBy),
      )
      .$if(orderWith === 'commentCount', (db) =>
        db.orderBy('totalCommentCount', orderBy).orderBy('post.id', orderBy),
      )
      .$if(
        keys != undefined &&
          keys.createdAt != undefined &&
          orderWith === 'createdAt',
        (db) => {
          return db.where((eb) =>
            eb(
              'post.createdAt',
              orderBy === 'asc' ? '>=' : '<=',
              keys!.createdAt!,
            ).and(
              eb(
                'post.createdAt',
                orderBy === 'asc' ? '>' : '<',
                keys!.createdAt!,
              ).or('post.id', '>', keys!.id),
            ),
          );
        },
      )
      .$if(
        keys != undefined &&
          keys.count != undefined &&
          orderWith === 'voteCount',
        (db) => {
          return db.where(({ eb, ref }) =>
            eb(
              eb
                .selectFrom('postVote')
                .whereRef('postVote.postId', '=', ref('post.id'))
                .where('postVote.voteTypeId', '!=', 2)
                .select(eb.fn.countAll().as('likeCount')),
              orderBy === 'asc' ? '>=' : '<=',
              keys!.count!,
            ).and(
              eb(
                eb
                  .selectFrom('postVote')
                  .whereRef('postVote.postId', '=', ref('post.id'))
                  .where('postVote.voteTypeId', '!=', 2)
                  .select(eb.fn.countAll().as('likeCount')),
                orderBy === 'asc' ? '>' : '<',
                keys!.count!,
              ).or('post.id', orderBy === 'asc' ? '>' : '<', keys!.id!),
            ),
          );
        },
      )
      .$if(
        !!keys && keys.count != undefined && orderWith === 'commentCount',
        (db) => {
          return db.where(({ eb, ref }) =>
            eb(
              eb
                .selectFrom('comment')
                .select(eb.fn.countAll().as('count'))
                .whereRef('comment.postId', '=', ref('post.id')),
              orderBy === 'asc' ? '>=' : '<=',
              keys!.count!,
            ).and(
              eb(
                eb
                  .selectFrom('comment')
                  .select(eb.fn.countAll().as('count'))
                  .whereRef('comment.postId', '=', ref('post.id')),
                orderBy === 'asc' ? '>' : '<',
                keys!.count!,
              ).or('post.id', orderBy === 'asc' ? '>' : '<', keys!.id!),
            ),
          );
        },
      )
      .$narrowType<{
        totalVote: NotNull;
        totalLike: NotNull;
        totalSmiley: NotNull;
        totalClap: NotNull;
        totalHeart: NotNull;
        parentId: NotNull;
        totalCommentCount: NotNull;
        richText: QuillDelta;
      }>()
      .limit(10)
      .execute();
  }

  async checkPostExistsByUser(id: string, userId: string) {
    return await this.db
      .selectFrom('post')
      .where('id', '=', id)
      .where('userId', '=', userId)
      .select('id')
      .executeTakeFirst();
  }

  async checkPostExists(id: string) {
    return await this.db
      .selectFrom('post')
      .where('id', '=', id)
      .where('post.postTypeId', '=', 1)
      .select('id')
      .executeTakeFirst();
  }

  async checkAnswerExists(id: string) {
    return await this.db
      .selectFrom('post')
      .where('id', '=', id)
      .where('post.postTypeId', '=', 2)
      .select('id')
      .executeTakeFirst();
  }

  async checkAnswerExistsByUser(id: string, userId: string) {
    return await this.db
      .selectFrom('post')
      .where('id', '=', id)
      .where('userId', '=', userId)
      .where('post.postTypeId', '=', 2)
      .select('id')
      .executeTakeFirst();
  }

  async updatePost(id: string, data: CreatePostDto, slug: string) {
    return await this.db.transaction().execute(async (trx) => {
      await trx.deleteFrom('postTag').where('postId', '=', id).execute();

      await trx
        .insertInto('postTag')
        .values(() => {
          return data.tags.map((tag) => ({
            postId: id,
            tagId: tag,
          }));
        })
        .execute();

      return await trx
        .updateTable('post')
        .set({
          body: getTextsFromDelta(data.richText),
          richText: json(data.richText),
          title: data.title,
          slug,
        })
        .where('id', '=', id)
        .where('postTypeId', '=', 1)
        .returning('id')
        .executeTakeFirstOrThrow(
          () => new NotFoundException('Gönderi bulunamadı'),
        );
    });
  }

  async votePost(postId: string, userId: string, voteTypeId: number) {
    return await this.db
      .insertInto('postVote')
      .values({
        postId,
        userId,
        voteTypeId,
      })
      .onConflict((oc) =>
        oc.columns(['postId', 'userId']).doUpdateSet({
          voteTypeId,
        }),
      )
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Gönderi bulunamadı'),
      );
  }

  deleteVote(postId: string, userId: string) {
    return this.db
      .deleteFrom('postVote')
      .where('postId', '=', postId)
      .where('userId', '=', userId)
      .execute();
  }

  async createAnswer(data: CreateAnswerDto, parentId: string, userId: string) {
    return await this.db
      .insertInto('post')
      .values({
        body: getTextsFromDelta(data.richText),
        richText: json(data.richText),
        parentId,
        userId,
        postTypeId: 2,
      })
      .returning('id')
      .onConflict((oc) => oc.doNothing())
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Gönderi bulunamadı'),
      );
  }

  async updateAnswer(id: string, data: CreateAnswerDto) {
    return await this.db
      .updateTable('post')
      .set({
        body: getTextsFromDelta(data.richText),
        richText: json(data.richText),
      })
      .where('id', '=', id)
      .returning('id')
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Gönderi bulunamadı'),
      );
  }

  async createComment(data: CreateAnswerDto, postId: string, userId: string) {
    return await this.db
      .insertInto('comment')
      .values({
        body: getTextsFromDelta(data.richText),
        richText: json(data.richText),
        postId,
        userId,
      })
      .returning('id')
      .onConflict((oc) => oc.doNothing())
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Gönderi bulunamadı'),
      );
  }

  async updateComment(id: string, data: CreateAnswerDto, userId: string) {
    return await this.db
      .updateTable('comment')
      .set({
        body: getTextsFromDelta(data.richText),
        richText: json(data.richText),
      })
      .where('id', '=', id)
      .where('userId', '=', userId)
      .returning('id')
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Gönderi bulunamadı'),
      );
  }

  async voteComment(commentId: string, userId: string, voteTypeId: number) {
    return await this.db
      .insertInto('commentVote')
      .values({
        commentId,
        userId,
        voteTypeId,
      })
      .onConflict((oc) =>
        oc.columns(['commentId', 'userId']).doUpdateSet({
          voteTypeId,
        }),
      )
      .executeTakeFirstOrThrow(() => new NotFoundException('Yorum bulunamadı'));
  }

  deleteCommentVote(commentId: string, userId: string) {
    return this.db
      .deleteFrom('commentVote')
      .where('commentId', '=', commentId)
      .where('userId', '=', userId)
      .execute();
  }

  async getPopularTags() {
    return this.db
      .selectFrom('tag')
      .select(['tag.id', 'tag.name', 'tag.createdAt', 'tag.updatedAt'])
      .select(({ ref, eb }) => [
        eb
          .selectFrom('postTag')
          .whereRef('postTag.tagId', '=', ref('tag.id'))
          .where(
            'postTag.createdAt',
            '>=',
            new Date(new Date().setMonth(new Date().getMonth() - 1)),
          )
          .select(
            eb.fn.countAll().$castTo<string>().$castTo<string>().as('count'),
          )
          .as('postCount'),
      ])
      .orderBy('postCount', 'desc')
      .$narrowType<{
        postCount: NotNull;
      }>()
      .limit(10)
      .execute();
  }

  async addBookmark(postId: string, userId: string) {
    return await this.db
      .insertInto('bookmarkedPost')
      .values({
        postId,
        userId,
      })
      .onConflict((oc) => oc.doNothing())
      .execute();
  }

  async removeBookmark(postId: string, userId: string) {
    return await this.db
      .deleteFrom('bookmarkedPost')
      .where('postId', '=', postId)
      .where('userId', '=', userId)
      .execute();
  }

  async getBookmarks(userId: string, keys?: { createdAt: Date; id: string }) {
    return await this.db
      .selectFrom('bookmarkedPost')
      .where('bookmarkedPost.userId', '=', userId)
      .innerJoin('post', 'post.id', 'bookmarkedPost.postId')
      .select([
        'post.id',
        'post.title',
        'post.body',
        'post.richText',
        'post.createdAt',
        'post.updatedAt',
        'post.slug',
        'post.postTypeId',
        'post.lastActivityDate',
      ])
      .select(({ ref, eb }) => [
        jsonObjectFrom(
          eb
            .selectFrom('user')
            .select(['user.id', 'user.username', 'user.avatarPath'])
            .whereRef('user.id', '=', ref('post.userId')),
        ).as('user'),

        eb
          .case()
          .when('post.selectedAnswerId', 'is not', null)
          .then(true)
          .else(false)
          .end()
          .as('isAnswered'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalVote'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '!=', 2)
          .as('totalVote'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalLike'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 1)
          .as('totalLike'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalSmiley'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 3)
          .as('totalSmiley'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalClap'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 4)
          .as('totalClap'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalHeart'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 5)
          .as('totalHeart'),

        eb
          .selectFrom('postVote')
          .select('voteTypeId')
          .where('userId', '=', userId)
          .where('postVote.postId', '=', ref('post.id'))
          .as('userVote'),

        eb
          .selectFrom('post as a')
          .select((eb) =>
            eb.fn.countAll().$castTo<string>().as('totalAnswerCount'),
          )
          .where('a.parentId', '=', ref('post.id'))
          .as('totalAnswerCount'),

        eb
          .exists((eb) =>
            eb
              .selectFrom('bookmarkedPost')
              .where('postId', '=', ref('post.id'))
              .where('userId', '=', userId),
          )
          .as('bookmarked'),

        jsonArrayFrom(
          eb
            .selectFrom('tag')
            .select(['tag.id', 'tag.name'])
            .whereRef(
              'tag.id',
              'in',
              eb
                .selectFrom('postTag')
                .select('tagId')
                .where('postId', '=', ref('post.id')),
            ),
        ).as('tags'),
      ])
      .$if(!!keys, (db) =>
        db.where((eb) =>
          eb('post.createdAt', '>=', keys!.createdAt).and(
            eb('post.createdAt', '>', keys!.createdAt).or(
              'post.id',
              '>',
              keys!.id,
            ),
          ),
        ),
      )
      .orderBy('post.createdAt', 'asc')
      .orderBy('post.id', 'asc')
      .limit(10)
      .$narrowType<{
        totalVote: NotNull;
        totalLike: NotNull;
        totalSmiley: NotNull;
        totalClap: NotNull;
        totalHeart: NotNull;
        totalAnswerCount: NotNull;
        title: NotNull;
        slug: NotNull;
        richText: QuillDelta;
      }>()
      .execute();
  }

  async setSelectedAnswer(postId: string, answerId: string, userId: string) {
    return await this.db
      .updateTable('post')
      .set({
        selectedAnswerId: answerId,
      })
      .where('id', '=', postId)
      .where('postTypeId', '=', 1)
      .where('userId', '=', userId)
      .returning('id')
      .executeTakeFirstOrThrow(
        () => new NotFoundException('Gönderi bulunamadı'),
      );
  }

  async checkAnswerExistsByPost(postId: string, answerId: string) {
    return await this.db
      .selectFrom('post')
      .where('id', '=', answerId)
      .where('parentId', '=', postId)
      .where('postTypeId', '=', 2)
      .select('id')
      .executeTakeFirstOrThrow(() => new NotFoundException('Cevap bulunamadı'));
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
    return await this.db
      .selectFrom('post')
      .select([
        'post.id',
        'post.title',
        'post.body',
        'post.richText',
        'post.createdAt',
        'post.updatedAt',
        'post.slug',
        'post.postTypeId',
        'post.lastActivityDate',
      ])
      .$if(!!tag, (db) =>
        db
          .innerJoin('postTag', 'postTag.postId', 'post.id')
          .where('postTag.tagId', '=', tag!),
      )
      .select(({ ref, eb }) => [
        jsonObjectFrom(
          eb
            .selectFrom('user')
            .select(['user.id', 'user.username', 'user.avatarPath'])
            .whereRef('user.id', '=', ref('post.userId')),
        ).as('user'),

        eb
          .case()
          .when('post.selectedAnswerId', 'is not', null)
          .then(true)
          .else(false)
          .end()
          .as('isAnswered'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalVote'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '!=', 2)
          .as('totalVote'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalLike'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 1)
          .as('totalLike'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalSmiley'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 3)
          .as('totalSmiley'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalClap'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 4)
          .as('totalClap'),

        eb
          .selectFrom('postVote')
          .select((eb) => eb.fn.countAll().$castTo<string>().as('totalHeart'))
          .where('postVote.postId', '=', ref('post.id'))
          .where('postVote.voteTypeId', '=', 5)
          .as('totalHeart'),

        eb
          .selectFrom('post as p')
          .select((eb) =>
            eb.fn.countAll().$castTo<string>().as('totalAnswerCount'),
          )
          .whereRef('p.parentId', '=', ref('post.id'))
          .as('totalAnswerCount'),

        jsonArrayFrom(
          eb
            .selectFrom('tag')
            .select(['tag.id', 'tag.name'])
            .whereRef(
              'tag.id',
              'in',
              eb
                .selectFrom('postTag')
                .select('tagId')
                .where('postId', '=', ref('post.id')),
            ),
        ).as('tags'),
      ])
      .$if(!!userId, (db) =>
        db.select(({ eb, ref }) => [
          eb
            .exists((eb) =>
              eb
                .selectFrom('bookmarkedPost')
                .where('postId', '=', ref('post.id'))
                .where('userId', '=', userId!),
            )
            .as('bookmarked'),

          eb
            .selectFrom('postVote')
            .select('voteTypeId')
            .where('userId', '=', userId!)
            .where('postId', '=', ref('post.id'))
            .as('userVote'),
        ]),
      )
      .$if(
        keys != undefined &&
          keys.date != undefined &&
          orderWith === 'lastActivity',
        (db) => {
          return db.where((eb) =>
            eb(
              'post.lastActivityDate',
              orderBy === 'asc' ? '>=' : '<=',
              keys!.date!,
            ).and(
              eb(
                'post.lastActivityDate',
                orderBy === 'asc' ? '>' : '<',
                keys!.date!,
              ).or('post.id', '>', keys!.id!),
            ),
          );
        },
      )
      .$if(
        keys != undefined &&
          keys.date != undefined &&
          orderWith === 'createdAt',
        (db) => {
          return db.where((eb) =>
            eb(
              'post.createdAt',
              orderBy === 'asc' ? '>=' : '<=',
              keys!.date!,
            ).and(
              eb(
                'post.createdAt',
                orderBy === 'asc' ? '>' : '<',
                keys!.date!,
              ).or('post.id', orderBy === 'asc' ? '>' : '<', keys!.id!),
            ),
          );
        },
      )
      .$if(
        keys != undefined &&
          keys.count != undefined &&
          orderWith === 'voteCount',
        (db) => {
          return db.where(({ eb, ref }) =>
            eb(
              eb
                .selectFrom('postVote')
                .whereRef('postVote.postId', '=', ref('post.id'))
                .where('postVote.voteTypeId', '!=', 2)
                .select(eb.fn.countAll().as('likeCount')),
              orderBy === 'asc' ? '>=' : '<=',
              keys!.count!,
            ).and(
              eb(
                eb
                  .selectFrom('postVote')
                  .whereRef('postVote.postId', '=', ref('post.id'))
                  .where('postVote.voteTypeId', '!=', 2)
                  .select(eb.fn.countAll().as('likeCount')),
                orderBy === 'asc' ? '>' : '<',
                keys!.count!,
              ).or('post.id', orderBy === 'asc' ? '>' : '<', keys!.id!),
            ),
          );
        },
      )
      .$if(
        !!keys && keys.count != undefined && orderWith === 'commentCount',
        (db) => {
          return db.where(({ eb, ref }) =>
            eb(
              eb
                .selectFrom('post as s')
                .select(eb.fn.countAll().as('count'))
                .whereRef('s.parentId', '=', ref('post.id')),
              orderBy === 'asc' ? '>=' : '<=',
              keys!.count!,
            ).and(
              eb(
                eb
                  .selectFrom('post as s')
                  .select(eb.fn.countAll().as('count'))
                  .whereRef('s.parentId', '=', ref('post.id')),
                orderBy === 'asc' ? '>' : '<',
                keys!.count!,
              ).or('post.id', orderBy === 'asc' ? '>' : '<', keys!.id!),
            ),
          );
        },
      )
      .$if(orderWith === 'lastActivity', (db) =>
        db.orderBy('lastActivityDate', orderBy).orderBy('post.id', orderBy),
      )
      .$if(orderWith === 'createdAt', (db) =>
        db.orderBy('post.createdAt', orderBy).orderBy('post.id', orderBy),
      )
      .$if(orderWith === 'voteCount', (db) =>
        db.orderBy('totalVote', orderBy).orderBy('post.id', orderBy),
      )
      .$if(orderWith === 'commentCount', (db) =>
        db.orderBy('totalAnswerCount', orderBy).orderBy('post.id', orderBy),
      )

      .where('post.postTypeId', '=', 1)
      .$narrowType<{
        totalVote: NotNull;
        totalLike: NotNull;
        totalSmiley: NotNull;
        totalClap: NotNull;
        totalHeart: NotNull;
        parentId: NotNull;
        totalAnswerCount: NotNull;
        title: NotNull;
        slug: NotNull;
        richText: QuillDelta;
      }>()
      .limit(10)
      .execute();
  }
}

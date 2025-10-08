import { Pool } from 'pg';
import {
  CamelCasePlugin,
  Kysely,
  ParseJSONResultsPlugin,
  PostgresDialect,
} from 'kysely';
import * as bcrypt from 'bcrypt';
import { faker } from '@faker-js/faker';
import { DB } from '../src/database/types';
import { gender } from '../src/database/enums';
import { createRandomDelta } from './seed-helper';
import { json } from '../src/database/extensions/json';
import { getTextsFromDelta } from '../src/utils/rich-text/get-texts-from-delta';

const dialect = new PostgresDialect({
  pool: new Pool({
    connectionString: process.env.DATABASE_URL,
  }),
});

const db = new Kysely<DB>({
  dialect,
  plugins: [new CamelCasePlugin(), new ParseJSONResultsPlugin()],
});

const roundsOfHashing = 10;

const userIds: string[] = [];

async function main() {
  const password = await bcrypt.hash('password', roundsOfHashing);

  const user = await db
    .insertInto('user')
    .values({
      email: 'biberonapp@gmail.com',
      emailVerified: true,
      password,
      username: 'Test Biberon',
      displayName: 'Test Biberon',
      updatedAt: new Date(),
    })
    .onConflict((oc) => oc.column('email').doNothing())
    .returningAll()
    .executeTakeFirst();

  if (!user) {
    return;
  }

  await db
    .insertInto('profile')
    .values({
      userId: user.id,
    })
    .onConflict((oc) => oc.column('userId').doNothing())
    .returningAll()
    .executeTakeFirst();

  console.log({ user });

  for (let i = 0; i < 100; i++) {
    try {
      await createUsers();
    } catch (e) {
      console.error(e);
    }

    if (i % 10 === 0) {
      console.log(i + ' users created');
    }
  }

  await createPosts();
}

const getRandomUserId = (number?: number, array = false) => {
  if (array) {
    // take users from the first n users
    const shuffled = userIds.sort(() => 0.5 - Math.random());
    return shuffled.slice(0, number);
  }
  const randomIndex = Math.floor(Math.random() * userIds.length);
  return userIds[randomIndex];
};

const createPosts = async () => {
  const posts: any[] = [];

  for (let i = 0; i < 100; i++) {
    const userId = getRandomUserId();

    const title = faker.lorem.words(5);
    const delta = createRandomDelta();

    const post = {
      id: faker.string.uuid(),
      userId,
      richText: json(delta),
      body: getTextsFromDelta(delta),
      slug: faker.helpers.slugify(title),
      title,
      createdAt: faker.date.past({
        years: 2,
      }),
    };

    posts.push(post);
  }

  await db.insertInto('post').values(posts).execute();

  for (const post of posts) {
    await votePosts(post.id);
    await createAnswers(post.id, post.createdAt);
    await createPostTags(post.id, post.createdAt);
    console.log('Post created');
  }
};

const createPostTags = async (postId: string, date: Date) => {
  const tags: any[] = [];

  const tag = {
    postId,
    tagId: faker.number.int({ min: 1, max: 15 }),
    createdAt: date,
  };

  tags.push(tag);

  await db.insertInto('postTag').values(tags).execute();
};

const createAnswers = async (postId: string, date: Date) => {
  const answers: any[] = [];

  for (let i = 0; i < Math.random() * 20; i++) {
    const userId = getRandomUserId();

    const delta = createRandomDelta();

    const answer = {
      id: faker.string.uuid(),
      userId,
      body: getTextsFromDelta(delta),
      richText: json(delta),
      parentId: postId,
      createdAt: faker.date.between({ from: date, to: new Date() }),
      postTypeId: 2,
    };

    answers.push(answer);
  }

  await db.insertInto('post').values(answers).execute();

  for (const answer of answers) {
    await votePosts(answer.id);
    await createComments(answer.id, answer.createdAt);
  }
};

const createComments = async (postId: string, date: Date) => {
  const comments: any[] = [];

  for (let i = 0; i < Math.random() * 3; i++) {
    const userId = getRandomUserId();
    const delta = createRandomDelta();

    const comment = {
      id: faker.string.uuid(),
      userId,
      body: getTextsFromDelta(delta),
      richText: json(delta),
      postId,
      createdAt: faker.date.between({ from: date, to: new Date() }),
    };

    comments.push(comment);
  }

  await db.insertInto('comment').values(comments).execute();

  for (const comment of comments) {
    await voteComments(comment.id);
  }
};

const voteComments = async (commentId: string) => {
  const voteNumber = Math.ceil(Math.random() * 10);
  const userIds = getRandomUserId(voteNumber, true);
  console.log({ voteNumber, userIds });
  const votes: { userId: string; commentId: string; voteTypeId: number }[] = [];
  for (const userId of userIds) {
    const vote = {
      userId,
      commentId,
      voteTypeId: faker.number.int({ min: 1, max: 5 }),
    };

    votes.push(vote);
  }

  try {
    await db.insertInto('commentVote').values(votes).execute();
  } catch (e) {
    console.error(e);
  }
};

const votePosts = async (postId: string) => {
  const voteNumber = Math.ceil(Math.random() * 10);
  const userIds = getRandomUserId(voteNumber, true);
  console.log({ voteNumber, userIds });
  const votes: { userId: string; postId: string; voteTypeId: number }[] = [];
  for (const userId of userIds) {
    const vote = {
      userId,
      postId,
      voteTypeId: faker.number.int({ min: 1, max: 5 }),
    };

    votes.push(vote);
  }

  try {
    await db.insertInto('postVote').values(votes).execute();
  } catch (e) {
    console.error(e);
  }
};

const createUsers = async () => {
  const user = await db
    .insertInto('user')
    .values({
      email: faker.internet.email(),
      password: faker.internet.password(),
      username: faker.internet.userName(),
      displayName: faker.internet.displayName(),
      updatedAt: faker.date.anytime(),
      emailVerified: true,
    })
    .returning('id')
    .executeTakeFirstOrThrow();

  await db
    .insertInto('profile')
    .values({
      userId: user.id,
    })
    .onConflict((oc) => oc.column('userId').doNothing())
    .returningAll()
    .executeTakeFirst();

  userIds.push(user.id);
};

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const inserFakeData = async () => {
  const user = await db
    .insertInto('user')
    .values({
      email: faker.internet.email(),
      password: faker.internet.password(),
      username: faker.internet.userName(),
      displayName: faker.internet.displayName(),
      updatedAt: faker.date.anytime(),
      emailVerified: true,
    })
    .returning('id')
    .executeTakeFirstOrThrow();

  await db
    .insertInto('verificationRequest')
    .values({
      code: faker.string.alphanumeric(6),
      userId: user.id,
      updatedAt: faker.date.anytime(),
      expires: faker.date.future(),
    })
    .executeTakeFirst();

  const profile = await db
    .insertInto('profile')
    .values({
      userId: user.id,
      bio: faker.lorem.sentence(),
      dateOfBirth: faker.date.past(),
      cityId: faker.number.int({ min: 1, max: 81 }),
      name: faker.person.fullName(),
    })
    .returning('id')
    .executeTakeFirstOrThrow();

  const isPregnant = faker.datatype.boolean();
  const isParent = faker.datatype.boolean();
  const howManyChildren = isParent ? faker.number.int({ min: 1, max: 10 }) : 0;
  const howManyPregnancy = howManyChildren;

  await db.updateTable('profile').set({ isPregnant, isParent }).execute();

  try {
    await insertPregnancy(profile.id, isPregnant, howManyPregnancy);
  } catch (e) {
    console.error(e);
  }

  try {
    await insertBaby(profile.id, howManyChildren);
  } catch (e) {
    console.error(e);
  }
};

const insertPregnancy = async (
  profileId: number,
  isPregnant: boolean,
  howManyPregnancy: number,
) => {
  if (isPregnant) {
    const pregnancy = await db
      .insertInto('pregnancy')
      .values({
        profileId,
        dueDate: faker.date.future(),
        birthGiven: false,
        isActive: true,
      })
      .returning('id')
      .executeTakeFirstOrThrow();

    await db
      .insertInto('fetus')
      .values({
        pregnancyId: pregnancy.id,
        gender: faker.helpers.enumValue(gender),
      })
      .execute();
  }

  for (let i = 0; i < howManyPregnancy; i++) {
    await db
      .insertInto('pregnancy')
      .values({
        profileId,
        dueDate: faker.date.past(),
        birthGiven: true,
        isActive: false,
      })
      .execute();
  }
};

const insertBaby = async (profileId: number, howManyChildren: number) => {
  for (let i = 0; i < howManyChildren; i++) {
    await db
      .insertInto('baby')
      .values({
        profileId,
        updatedAt: new Date(),
        dateOfBirth: faker.date.past(),
        name: faker.person.fullName(),
        gender: faker.helpers.enumValue(gender),
      })
      .execute();
  }
};

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await db.destroy();
  });

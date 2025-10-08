export const orderWith = {
  createdAt: 'createdAt',
  voteCount: 'voteCount',
  commentCount: 'commentCount',
} as const;

export type orderWith = (typeof orderWith)[keyof typeof orderWith];

export const orderBy = {
  asc: 'asc',
  desc: 'desc',
} as const;

export type orderBy = (typeof orderBy)[keyof typeof orderBy];

export const orderWithFeed = {
  createdAt: 'createdAt',
  voteCount: 'voteCount',
  commentCount: 'commentCount',
  lastActivity: 'lastActivity',
} as const;

export type orderWithFeed = (typeof orderWithFeed)[keyof typeof orderWithFeed];

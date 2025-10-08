import type { ColumnType } from 'kysely';
export type Generated<T> =
  T extends ColumnType<infer S, infer I, infer U>
    ? ColumnType<S, I | undefined, U>
    : ColumnType<T, T | undefined, T>;
export type Timestamp = ColumnType<Date, Date | string, Date | string>;

import type {
  gender,
  pregnancyType,
  role,
  provider,
  status,
  deliveryType,
} from './enums';

export type Baby = {
  id: Generated<number>;
  profileId: number;
  gender: Generated<gender>;
  dateOfBirth: Timestamp;
  birthTime: Timestamp | null;
  createdAt: Generated<Timestamp>;
  updatedAt: Generated<Timestamp>;
  name: string;
  birthWeight: number | null;
  birthHeight: number | null;
  notes: string | null;
};
export type BookmarkedPost = {
  userId: string;
  postId: string;
  createdAt: Generated<Timestamp>;
};
export type City = {
  id: Generated<number>;
  name: string;
};
export type Comment = {
  id: Generated<string>;
  postId: string;
  userId: string | null;
  body: string;
  richText: unknown;
  createdAt: Generated<Timestamp>;
  updatedAt: Generated<Timestamp>;
};
export type CommentVote = {
  commentId: string;
  userId: string;
  voteTypeId: number;
};
export type Fcmtoken = {
  id: Generated<string>;
  token: string;
  userId: string;
};
export type Fetus = {
  id: Generated<number>;
  pregnancyId: number;
  gender: Generated<gender>;
};
export type PasswordResetRequest = {
  id: Generated<number>;
  token: string;
  expires: Timestamp;
  createdAt: Generated<Timestamp>;
  updatedAt: Generated<Timestamp>;
  retry: Generated<number>;
  userId: string;
  status: Generated<status>;
};
export type Post = {
  id: Generated<string>;
  title: string | null;
  body: string;
  richText: unknown;
  parentId: string | null;
  userId: string | null;
  createdAt: Generated<Timestamp>;
  updatedAt: Generated<Timestamp>;
  lastActivityDate: Generated<Timestamp>;
  slug: string | null;
  postTypeId: Generated<number>;
  selectedAnswerId: string | null;
};
export type PostTag = {
  postId: string;
  tagId: number;
  createdAt: Generated<Timestamp>;
};
export type PostType = {
  id: Generated<number>;
  name: string;
};
export type PostVote = {
  postId: string;
  userId: string;
  voteTypeId: number;
};
export type Pregnancy = {
  id: Generated<number>;
  profileId: number;
  endDate: Timestamp | null;
  dueDate: Timestamp;
  lastPeriodDate: Timestamp | null;
  birthGiven: Generated<boolean>;
  deliveryType: Generated<deliveryType | null>;
  type: Generated<pregnancyType>;
  isActive: Generated<boolean>;
  notes: string | null;
};
export type Profile = {
  id: Generated<number>;
  userId: string;
  cityId: number | null;
  name: string | null;
  bio: string | null;
  specializationId: number | null;
  dateOfBirth: Timestamp | null;
  isPregnant: Generated<boolean | null>;
  isParent: Generated<boolean | null>;
};
export type Session = {
  id: Generated<string>;
  userId: string;
  createdAt: Generated<Timestamp>;
  lastActivity: Generated<Timestamp>;
  expiresAt: Timestamp;
  token: string;
};
export type Specialization = {
  id: Generated<number>;
  name: string;
};
export type Tag = {
  id: Generated<number>;
  name: string;
  createdAt: Generated<Timestamp>;
  updatedAt: Generated<Timestamp>;
};
export type User = {
  id: Generated<string>;
  email: string;
  password: string | null;
  provider: Generated<provider>;
  role: Generated<role>;
  createdAt: Generated<Timestamp>;
  updatedAt: Generated<Timestamp>;
  emailVerified: Generated<boolean>;
  socialId: string | null;
  username: string;
  displayName: string;
  avatarPath: string | null;
  avatarUpdatedAt: Timestamp | null;
  avatarUploadRequestedAt: Timestamp | null;
};
export type UserAgreement = {
  id: Generated<number>;
  userId: string;
  agreedAt: Generated<Timestamp>;
};
export type VerificationRequest = {
  id: Generated<number>;
  code: string;
  expires: Timestamp;
  createdAt: Generated<Timestamp>;
  updatedAt: Generated<Timestamp>;
  retry: Generated<number>;
  userId: string;
  status: Generated<status>;
};
export type VoteType = {
  id: Generated<number>;
  name: string;
};
export type DB = {
  baby: Baby;
  bookmarkedPost: BookmarkedPost;
  city: City;
  comment: Comment;
  commentVote: CommentVote;
  fcmToken: Fcmtoken;
  fetus: Fetus;
  passwordResetRequest: PasswordResetRequest;
  post: Post;
  postTag: PostTag;
  postType: PostType;
  postVote: PostVote;
  pregnancy: Pregnancy;
  profile: Profile;
  session: Session;
  specialization: Specialization;
  tag: Tag;
  user: User;
  userAgreement: UserAgreement;
  verificationRequest: VerificationRequest;
  voteType: VoteType;
};

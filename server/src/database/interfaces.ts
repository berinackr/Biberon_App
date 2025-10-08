import {
  Baby,
  City,
  Fetus,
  Generated,
  Pregnancy,
  Profile,
  Specialization,
  Timestamp,
  User,
  Comment,
  Post,
  Tag,
  PostVote,
  CommentVote,
} from './types';

type RemoveGenerated<T> = {
  [K in keyof T]: T[K] extends Generated<Timestamp>
    ? Timestamp
    : T[K] extends Generated<infer U>
      ? U
      : T[K];
};

type ReplaceTimestampWithDate<T> = {
  [K in keyof T]: T[K] extends Timestamp
    ? Date
    : T[K] extends Timestamp | null
      ? Date | null
      : T[K];
};

export type UserSelect = ReplaceTimestampWithDate<RemoveGenerated<User>>;
export type BabySelect = ReplaceTimestampWithDate<RemoveGenerated<Baby>>;
export type CitySelect = RemoveGenerated<City>;
export type FetusSelect = ReplaceTimestampWithDate<RemoveGenerated<Fetus>>;
export type PregnancySelect = ReplaceTimestampWithDate<
  RemoveGenerated<Pregnancy>
>;
export type ProfileSelect = ReplaceTimestampWithDate<RemoveGenerated<Profile>>;
export type SpecializationSelect = RemoveGenerated<Specialization>;
export type CommentSelect = ReplaceTimestampWithDate<RemoveGenerated<Comment>>;
export type PostSelect = ReplaceTimestampWithDate<RemoveGenerated<Post>>;
export type TagSelect = ReplaceTimestampWithDate<RemoveGenerated<Tag>>;
export type PostVoteSelect = RemoveGenerated<PostVote>;
export type CommentVoteSelect = RemoveGenerated<CommentVote>;

import 'package:biberon/features/forum/domain/models/delta_model.dart';
import 'package:biberon/features/forum/domain/models/forum_tag_model.dart';
import 'package:biberon/features/forum/domain/models/forum_user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forum_post_model.g.dart';

@JsonSerializable()
class Post {
  Post({
    this.id,
    this.title,
    this.body,
    this.richText,
    this.createdAt,
    this.updatedAt,
    this.lastActivityDate,
    this.slug,
    this.totalAnswerCount,
    this.userVote,
    this.bookmarked,
    this.user,
    this.isAnswered,
    this.totalVote,
    this.totalLike,
    this.totalSmiley,
    this.totalClap,
    this.totalHeart,
    this.tags,
  });

  // factory Post.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'body')
  final String? body;
  @JsonKey(name: 'richText')
  final List<DeltaModel>? richText;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @JsonKey(name: 'lastActivityDate')
  final DateTime? lastActivityDate;
  @JsonKey(name: 'slug')
  final String? slug;
  @JsonKey(name: 'totalAnswerCount')
  final int? totalAnswerCount;
  @JsonKey(name: 'userVote')
  final int? userVote;
  @JsonKey(name: 'bookmarked')
  final bool? bookmarked;
  @JsonKey(name: 'user')
  final User? user;
  @JsonKey(name: 'isAnswered')
  final bool? isAnswered;
  @JsonKey(name: 'totalVote')
  final int? totalVote;
  @JsonKey(name: 'totalLike')
  final int? totalLike;
  @JsonKey(name: 'totalSmiley')
  final int? totalSmiley;
  @JsonKey(name: 'totalClap')
  final int? totalClap;
  @JsonKey(name: 'totalHeart')
  final int? totalHeart;
  @JsonKey(name: 'tags')
  final List<Tag>? tags;

  Post copyWith({
    String? id,
    String? title,
    String? body,
    List<DeltaModel>? richText,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActivityDate,
    String? slug,
    int? totalAnswerCount,
    int? userVote,
    bool? bookmarked,
    User? user,
    bool? isAnswered,
    int? totalVote,
    int? totalLike,
    int? totalSmiley,
    int? totalClap,
    int? totalHeart,
    List<Tag>? tags,
  }) =>
      Post(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastActivityDate: lastActivityDate ?? this.lastActivityDate,
        slug: slug ?? this.slug,
        totalAnswerCount: totalAnswerCount ?? this.totalAnswerCount,
        userVote: userVote ?? this.userVote,
        bookmarked: bookmarked ?? this.bookmarked,
        user: user ?? this.user,
        isAnswered: isAnswered ?? this.isAnswered,
        totalVote: totalVote ?? this.totalVote,
        totalLike: totalLike ?? this.totalLike,
        totalSmiley: totalSmiley ?? this.totalSmiley,
        totalClap: totalClap ?? this.totalClap,
        totalHeart: totalHeart ?? this.totalHeart,
        tags: tags ?? this.tags,
      );

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

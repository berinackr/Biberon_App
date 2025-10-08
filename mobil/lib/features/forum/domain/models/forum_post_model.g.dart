// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      richText: (json['richText'] as List<dynamic>?)
          ?.map((e) => DeltaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastActivityDate: json['lastActivityDate'] == null
          ? null
          : DateTime.parse(json['lastActivityDate'] as String),
      slug: json['slug'] as String?,
      totalAnswerCount: (json['totalAnswerCount'] as num?)?.toInt(),
      userVote: (json['userVote'] as num?)?.toInt(),
      bookmarked: json['bookmarked'] as bool?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      isAnswered: json['isAnswered'] as bool?,
      totalVote: (json['totalVote'] as num?)?.toInt(),
      totalLike: (json['totalLike'] as num?)?.toInt(),
      totalSmiley: (json['totalSmiley'] as num?)?.toInt(),
      totalClap: (json['totalClap'] as num?)?.toInt(),
      totalHeart: (json['totalHeart'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'richText': instance.richText,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastActivityDate': instance.lastActivityDate?.toIso8601String(),
      'slug': instance.slug,
      'totalAnswerCount': instance.totalAnswerCount,
      'userVote': instance.userVote,
      'bookmarked': instance.bookmarked,
      'user': instance.user,
      'isAnswered': instance.isAnswered,
      'totalVote': instance.totalVote,
      'totalLike': instance.totalLike,
      'totalSmiley': instance.totalSmiley,
      'totalClap': instance.totalClap,
      'totalHeart': instance.totalHeart,
      'tags': instance.tags,
    };

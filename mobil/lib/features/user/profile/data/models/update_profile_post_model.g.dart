// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfilePostModel _$UpdateProfilePostModelFromJson(
  Map<String, dynamic> json,
) =>
    UpdateProfilePostModel(
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      cityId: (json['cityId'] as num?)?.toInt(),
      name: json['name'] as String?,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$UpdateProfilePostModelToJson(
  UpdateProfilePostModel instance,
) =>
    <String, dynamic>{
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'cityId': instance.cityId,
      'name': instance.name,
      'bio': instance.bio,
    };

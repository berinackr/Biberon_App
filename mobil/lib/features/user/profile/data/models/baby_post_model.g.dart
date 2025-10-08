// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baby_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BabyPostModel _$BabyPostModelFromJson(Map<String, dynamic> json) =>
    BabyPostModel(
      gender: json['gender'] as String,
      name: json['name'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      birthTime: json['birthTime'] as String?,
      birthWeight: (json['birthWeight'] as num?)?.toInt(),
      birthHeight: (json['birthHeight'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$BabyPostModelToJson(BabyPostModel instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'birthTime': instance.birthTime,
      'name': instance.name,
      'birthWeight': instance.birthWeight,
      'birthHeight': instance.birthHeight,
      'notes': instance.notes,
    };

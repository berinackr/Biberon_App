// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baby_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Baby _$BabyFromJson(Map<String, dynamic> json) => Baby(
      id: (json['id'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      name: json['name'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      notes: json['notes'] as String?,
      birthTime: json['birthTime'] as String?,
      birthWeight: (json['birthWeight'] as num?)?.toInt(),
      birthHeight: (json['birthHeight'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BabyToJson(Baby instance) => <String, dynamic>{
      'notes': instance.notes,
      'id': instance.id,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'birthTime': instance.birthTime,
      'name': instance.name,
      'birthWeight': instance.birthWeight,
      'birthHeight': instance.birthHeight,
    };

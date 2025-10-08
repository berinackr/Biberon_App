// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetus_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fetus _$FetusFromJson(Map<String, dynamic> json) => Fetus(
      id: (json['id'] as num).toInt(),
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$FetusToJson(Fetus instance) => <String, dynamic>{
      'id': instance.id,
      'gender': instance.gender,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PregnancyPostModel _$PregnancyPostModelFromJson(Map<String, dynamic> json) =>
    PregnancyPostModel(
      birthGiven: json['birthGiven'] as bool,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      lastPeriodDate: json['lastPeriodDate'] == null
          ? null
          : DateTime.parse(json['lastPeriodDate'] as String),
      notes: json['notes'] as String?,
      deliveryType: json['deliveryType'] as String?,
      type: json['type'] as String?,
      fetuses: (json['fetuses'] as List<dynamic>?)
          ?.map((e) => FetusPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PregnancyPostModelToJson(PregnancyPostModel instance) =>
    <String, dynamic>{
      'dueDate': instance.dueDate?.toIso8601String(),
      'birthGiven': instance.birthGiven,
      'lastPeriodDate': instance.lastPeriodDate?.toIso8601String(),
      'notes': instance.notes,
      'deliveryType': instance.deliveryType,
      'type': instance.type,
      'fetuses': instance.fetuses,
    };

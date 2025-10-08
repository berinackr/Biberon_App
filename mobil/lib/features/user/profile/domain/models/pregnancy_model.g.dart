// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pregnancy _$PregnancyFromJson(Map<String, dynamic> json) => Pregnancy(
      isActive: json['isActive'] as bool,
      id: (json['id'] as num).toInt(),
      birthGiven: json['birthGiven'] as bool,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      type: json['type'] as String?,
      deliveryType: json['deliveryType'] as String?,
      notes: json['notes'] as String?,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      lastPeriodDate: json['lastPeriodDate'] == null
          ? null
          : DateTime.parse(json['lastPeriodDate'] as String),
      fetuses: (json['fetuses'] as List<dynamic>?)
          ?.map((e) => Fetus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PregnancyToJson(Pregnancy instance) => <String, dynamic>{
      'deliveryType': instance.deliveryType,
      'isActive': instance.isActive,
      'notes': instance.notes,
      'id': instance.id,
      'endDate': instance.endDate?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'lastPeriodDate': instance.lastPeriodDate?.toIso8601String(),
      'birthGiven': instance.birthGiven,
      'type': instance.type,
      'fetuses': instance.fetuses,
    };

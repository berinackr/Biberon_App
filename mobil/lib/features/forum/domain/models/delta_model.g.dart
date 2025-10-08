// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeltaModel _$DeltaModelFromJson(Map<String, dynamic> json) => DeltaModel(
      insert: json['insert'] as String?,
      attributes: json['attributes'] == null
          ? null
          : DeltaAttributes.fromJson(
              json['attributes'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$DeltaModelToJson(DeltaModel instance) =>
    <String, dynamic>{
      'insert': instance.insert,
      'attributes': instance.attributes,
    };

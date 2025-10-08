// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delta_attributes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeltaAttributes _$DeltaAttributesFromJson(Map<String, dynamic> json) =>
    DeltaAttributes(
      link: json['link'] as String?,
      bold: json['bold'] as bool?,
      italic: json['italic'] as bool?,
      underline: json['underline'] as bool?,
      strike: json['strike'] as bool?,
      blockquote: json['blockquote'] as bool?,
      list: json['list'] as String?,
    );

Map<String, dynamic> _$DeltaAttributesToJson(DeltaAttributes instance) =>
    <String, dynamic>{
      'link': instance.link,
      'bold': instance.bold,
      'italic': instance.italic,
      'underline': instance.underline,
      'strike': instance.strike,
      'blockquote': instance.blockquote,
      'list': instance.list,
    };

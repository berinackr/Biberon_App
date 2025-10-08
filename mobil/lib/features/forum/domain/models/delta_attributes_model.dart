import 'package:json_annotation/json_annotation.dart';

part 'delta_attributes_model.g.dart';

@JsonSerializable()
class DeltaAttributes {
  DeltaAttributes({
    this.link,
    this.bold,
    this.italic,
    this.underline,
    this.strike,
    this.blockquote,
    this.list,
  });

  factory DeltaAttributes.fromJson(Map<String, dynamic> json) =>
      _$DeltaAttributesFromJson(json);
  final String? link;
  final bool? bold;
  final bool? italic;
  final bool? underline;
  final bool? strike;
  final bool? blockquote;
  final String? list;

  Map<String, dynamic> toJson() => _$DeltaAttributesToJson(this);
}

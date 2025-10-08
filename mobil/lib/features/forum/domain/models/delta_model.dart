import 'package:biberon/features/forum/domain/models/delta_attributes_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delta_model.g.dart';

@JsonSerializable()
class DeltaModel {
  DeltaModel({
    this.insert,
    this.attributes,
  });

  factory DeltaModel.fromJson(Map<String, dynamic> json) =>
      _$DeltaModelFromJson(json);
  final String? insert;
  final DeltaAttributes? attributes;

  Map<String, dynamic> toJson() => _$DeltaModelToJson(this);
}

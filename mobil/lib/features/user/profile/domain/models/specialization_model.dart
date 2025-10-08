import 'package:json_annotation/json_annotation.dart';

part 'specialization_model.g.dart';

@JsonSerializable()
class Specialization {
  Specialization({
    required this.id,
    required this.name,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) =>
      _$SpecializationFromJson(json);
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;

  Specialization copyWith({
    int? id,
    String? name,
  }) =>
      Specialization(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() => _$SpecializationToJson(this);
}

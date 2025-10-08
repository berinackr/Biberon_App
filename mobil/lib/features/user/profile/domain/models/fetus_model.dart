import 'package:json_annotation/json_annotation.dart';

part 'fetus_model.g.dart';

@JsonSerializable()
class Fetus {
  const Fetus({
    required this.id,
    required this.gender,
  });

  factory Fetus.fromJson(Map<String, dynamic> json) => _$FetusFromJson(json);
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'gender')
  final String gender;

  Fetus copyWith({
    int? id,
    String? gender,
  }) =>
      Fetus(
        id: id ?? this.id,
        gender: gender ?? this.gender,
      );

  Map<String, dynamic> toJson() => _$FetusToJson(this);
}

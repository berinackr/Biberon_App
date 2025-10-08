import 'package:json_annotation/json_annotation.dart';

part 'baby_model.g.dart';

@JsonSerializable()
class Baby {
  Baby({
    this.id,
    this.gender,
    this.name,
    this.dateOfBirth,
    this.notes,
    this.birthTime,
    this.birthWeight,
    this.birthHeight,
  });
  factory Baby.fromJson(Map<String, dynamic> json) => _$BabyFromJson(json);
  @JsonKey(name: 'notes')
  final String? notes;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'gender')
  final String? gender;
  @JsonKey(name: 'dateOfBirth')
  final DateTime? dateOfBirth;
  @JsonKey(name: 'birthTime')
  final String? birthTime;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'birthWeight')
  final int? birthWeight;
  @JsonKey(name: 'birthHeight')
  final int? birthHeight;

  Baby copyWith({
    String? notes,
    int? id,
    String? gender,
    DateTime? dateOfBirth,
    String? birthTime,
    String? name,
    int? birthWeight,
    int? birthHeight,
  }) =>
      Baby(
        notes: notes ?? this.notes,
        id: id ?? this.id,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        birthTime: birthTime ?? this.birthTime,
        name: name ?? this.name,
        birthWeight: birthWeight ?? this.birthWeight,
        birthHeight: birthHeight ?? this.birthHeight,
      );

  Map<String, dynamic> toJson() => _$BabyToJson(this);
}

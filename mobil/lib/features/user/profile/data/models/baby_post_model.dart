// To parse this JSON data, do
//
//     final babyPostModel = babyPostModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'baby_post_model.g.dart';

BabyPostModel babyPostModelFromJson(String str) =>
    BabyPostModel.fromJson(json.decode(str) as Map<String, dynamic>);

String babyPostModelToJson(BabyPostModel data) => json.encode(data.toJson());

@JsonSerializable()
class BabyPostModel {
  BabyPostModel({
    required this.gender,
    this.name,
    this.dateOfBirth,
    this.birthTime,
    this.birthWeight,
    this.birthHeight,
    this.notes,
  });

  factory BabyPostModel.fromJson(Map<String, dynamic> json) =>
      _$BabyPostModelFromJson(json);

  @JsonKey(name: 'gender')
  final String gender;
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
  @JsonKey(name: 'notes')
  final String? notes;

  BabyPostModel copyWith({
    String? gender,
    DateTime? dateOfBirth,
    String? birthTime,
    String? name,
    int? birthWeight,
    int? birthHeight,
    String? notes,
  }) =>
      BabyPostModel(
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        birthTime: birthTime ?? this.birthTime,
        name: name ?? this.name,
        birthWeight: birthWeight ?? this.birthWeight,
        birthHeight: birthHeight ?? this.birthHeight,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toJson() => _$BabyPostModelToJson(this);
}

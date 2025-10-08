// To parse this JSON data, do
//
//     final pregnancyPostModel = pregnancyPostModelFromJson(jsonString);

import 'dart:convert';

import 'package:biberon/features/user/profile/data/models/fetus_post_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pregnancy_post_model.g.dart';

PregnancyPostModel pregnancyPostModelFromJson(String str) =>
    PregnancyPostModel.fromJson(json.decode(str) as Map<String, dynamic>);

String pregnancyPostModelToJson(PregnancyPostModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class PregnancyPostModel {
  PregnancyPostModel({
    required this.birthGiven,
    this.dueDate,
    this.lastPeriodDate,
    this.notes,
    this.deliveryType,
    this.type,
    this.fetuses,
  });

  factory PregnancyPostModel.fromJson(Map<String, dynamic> json) =>
      _$PregnancyPostModelFromJson(json);
  @JsonKey(name: 'dueDate')
  final DateTime? dueDate;
  @JsonKey(name: 'birthGiven')
  final bool birthGiven;
  @JsonKey(name: 'lastPeriodDate')
  final DateTime? lastPeriodDate;
  @JsonKey(name: 'notes')
  final String? notes;
  @JsonKey(name: 'deliveryType')
  final String? deliveryType;
  @JsonKey(name: 'type')
  final String? type;
  @JsonKey(name: 'fetuses')
  final List<FetusPostModel>? fetuses;

  PregnancyPostModel copyWith({
    DateTime? dueDate,
    bool? birthGiven,
    DateTime? lastPeriodDate,
    String? notes,
    String? deliveryType,
    String? type,
    List<FetusPostModel>? fetuses,
  }) =>
      PregnancyPostModel(
        dueDate: dueDate ?? this.dueDate,
        birthGiven: birthGiven ?? this.birthGiven,
        lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
        notes: notes ?? this.notes,
        deliveryType: deliveryType ?? this.deliveryType,
        type: type ?? this.type,
        fetuses: fetuses ?? this.fetuses,
      );

  Map<String, dynamic> toJson() => _$PregnancyPostModelToJson(this);
}

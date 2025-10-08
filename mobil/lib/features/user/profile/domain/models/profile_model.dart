// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

import 'package:biberon/features/user/profile/domain/models/baby_model.dart';
import 'package:biberon/features/user/profile/domain/models/city_model.dart';
import 'package:biberon/features/user/profile/domain/models/pregnancy_model.dart';
import 'package:biberon/features/user/profile/domain/models/specialization_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str) as Map<String, dynamic>);

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

@JsonSerializable()
class ProfileModel {
  ProfileModel({
    required this.userId,
    this.bio,
    this.specializationId,
    this.cityId,
    this.dateOfBirth,
    this.name,
    this.isPregnant,
    this.isParent,
    this.babies,
    this.pregnancies,
    this.city,
    this.specialization,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  @JsonKey(name: 'bio')
  final String? bio;
  @JsonKey(name: 'specializationId')
  final int? specializationId;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'cityId')
  final int? cityId;
  @JsonKey(name: 'dateOfBirth')
  final DateTime? dateOfBirth;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'isPregnant')
  final bool? isPregnant;
  @JsonKey(name: 'isParent')
  final bool? isParent;
  @JsonKey(name: 'babies')
  final List<Baby>? babies;
  @JsonKey(name: 'pregnancies')
  final List<Pregnancy>? pregnancies;
  @JsonKey(name: 'city')
  final City? city;
  @JsonKey(name: 'specialization')
  final Specialization? specialization;

  ProfileModel copyWith({
    String? bio,
    int? specializationId,
    String? userId,
    int? cityId,
    DateTime? dateOfBirth,
    String? name,
    bool? isPregnant,
    bool? isParent,
    List<Baby>? babies,
    List<Pregnancy>? pregnancies,
    City? city,
    Specialization? specialization,
  }) =>
      ProfileModel(
        bio: bio ?? this.bio,
        specializationId: specializationId ?? this.specializationId,
        userId: userId ?? this.userId,
        cityId: cityId ?? this.cityId,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        name: name ?? this.name,
        isPregnant: isPregnant ?? this.isPregnant,
        isParent: isParent ?? this.isParent,
        babies: babies ?? this.babies,
        pregnancies: pregnancies ?? this.pregnancies,
        city: city ?? this.city,
        specialization: specialization ?? this.specialization,
      );

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

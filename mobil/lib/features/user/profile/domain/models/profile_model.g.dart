// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      userId: json['userId'] as String,
      bio: json['bio'] as String?,
      specializationId: (json['specializationId'] as num?)?.toInt(),
      cityId: (json['cityId'] as num?)?.toInt(),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      name: json['name'] as String?,
      isPregnant: json['isPregnant'] as bool?,
      isParent: json['isParent'] as bool?,
      babies: (json['babies'] as List<dynamic>?)
          ?.map((e) => Baby.fromJson(e as Map<String, dynamic>))
          .toList(),
      pregnancies: (json['pregnancies'] as List<dynamic>?)
          ?.map((e) => Pregnancy.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      specialization: json['specialization'] == null
          ? null
          : Specialization.fromJson(
              json['specialization'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'specializationId': instance.specializationId,
      'userId': instance.userId,
      'cityId': instance.cityId,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'name': instance.name,
      'isPregnant': instance.isPregnant,
      'isParent': instance.isParent,
      'babies': instance.babies,
      'pregnancies': instance.pregnancies,
      'city': instance.city,
      'specialization': instance.specialization,
    };

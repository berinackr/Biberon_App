// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupPostModel _$SignupPostModelFromJson(Map<String, dynamic> json) =>
    SignupPostModel(
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$SignupPostModelToJson(SignupPostModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'username': instance.username,
    };

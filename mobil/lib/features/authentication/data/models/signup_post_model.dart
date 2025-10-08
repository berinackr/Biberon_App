import 'package:json_annotation/json_annotation.dart';

part 'signup_post_model.g.dart';

@JsonSerializable()
class SignupPostModel {
  SignupPostModel({
    required this.email,
    required this.password,
    required this.username,
  });

  factory SignupPostModel.fromJson(Map<String, dynamic> json) =>
      _$SignupPostModelFromJson(json);
  String email;
  String password;
  String username;

  Map<String, dynamic> toJson() => _$SignupPostModelToJson(this);
}

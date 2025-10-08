import 'package:json_annotation/json_annotation.dart';

part 'login_post_model.g.dart';

@JsonSerializable()
class LoginPostModel {
  LoginPostModel({
    required this.email,
    required this.password,
  });

  factory LoginPostModel.fromJson(Map<String, dynamic> json) =>
      _$LoginPostModelFromJson(json);
  String email;
  String password;

  Map<String, dynamic> toJson() => _$LoginPostModelToJson(this);
}

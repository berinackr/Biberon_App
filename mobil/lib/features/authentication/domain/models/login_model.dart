import 'package:biberon/features/authentication/domain/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  LoginModel({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
  String token;
  String refreshToken;
  DateTime expiresAt;
  UserModel user;

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}

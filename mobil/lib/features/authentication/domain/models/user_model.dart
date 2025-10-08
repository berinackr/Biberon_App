import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.id,
    required this.role,
    required this.email,
    required this.username,
    required this.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// The users id
  String id;

  /// The users role
  String role;

  /// The users email address
  String email;

  /// The users name
  String username;

  /// The users email verification status
  bool emailVerified;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

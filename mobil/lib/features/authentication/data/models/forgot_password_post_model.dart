import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_post_model.g.dart';

@JsonSerializable()
class ForgotPasswordPostModel {
  ForgotPasswordPostModel({
    required this.email,
  });

  factory ForgotPasswordPostModel.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordPostModelFromJson(json);

  final String email;

  Map<String, dynamic> toJson() => _$ForgotPasswordPostModelToJson(this);
}

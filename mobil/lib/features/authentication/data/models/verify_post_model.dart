import 'package:json_annotation/json_annotation.dart';

part 'verify_post_model.g.dart';

@JsonSerializable()
class VerifyPostModel {
  VerifyPostModel({
    required this.code,
  });

  factory VerifyPostModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyPostModelFromJson(json);
  String code;

  Map<String, dynamic> toJson() => _$VerifyPostModelToJson(this);
}

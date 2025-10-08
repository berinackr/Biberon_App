import 'package:json_annotation/json_annotation.dart';

part 'response_error_model.g.dart';

@JsonSerializable()
class ResponseErrorModel {
  ResponseErrorModel({
    required this.message,
    required this.statusCode,
  });

  factory ResponseErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorModelFromJson(json);
  String message;
  int statusCode;

  Map<String, dynamic> toJson() => _$ResponseErrorModelToJson(this);
}

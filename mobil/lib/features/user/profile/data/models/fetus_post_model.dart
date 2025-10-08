import 'package:json_annotation/json_annotation.dart';

part 'fetus_post_model.g.dart';

@JsonSerializable()
class FetusPostModel {
  FetusPostModel({
    required this.gender,
  });

  factory FetusPostModel.fromJson(Map<String, dynamic> json) =>
      _$FetusPostModelFromJson(json);
  @JsonKey(name: 'gender')
  final String gender;

  FetusPostModel copyWith({
    String? gender,
  }) =>
      FetusPostModel(
        gender: gender ?? this.gender,
      );

  Map<String, dynamic> toJson() => _$FetusPostModelToJson(this);
}

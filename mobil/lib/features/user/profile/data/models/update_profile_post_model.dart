import 'package:json_annotation/json_annotation.dart';

part 'update_profile_post_model.g.dart';

@JsonSerializable()
class UpdateProfilePostModel {
  UpdateProfilePostModel({
    this.dateOfBirth,
    this.cityId,
    this.name,
    this.bio,
  });

  factory UpdateProfilePostModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfilePostModelFromJson(json);
  @JsonKey(name: 'dateOfBirth')
  final DateTime? dateOfBirth;
  @JsonKey(name: 'cityId')
  final int? cityId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'bio')
  final String? bio;

  Map<String, dynamic> toJson() => _$UpdateProfilePostModelToJson(this);
}

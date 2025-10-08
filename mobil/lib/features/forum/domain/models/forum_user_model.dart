import 'package:json_annotation/json_annotation.dart';

part 'forum_user_model.g.dart';

@JsonSerializable()
class User {
  User({
    this.id,
    this.username,
    this.avatarPath,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'avatarPath')
  final String? avatarPath;

  User copyWith({
    String? id,
    String? username,
    String? avatarPath,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        avatarPath: avatarPath ?? this.avatarPath,
      );

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

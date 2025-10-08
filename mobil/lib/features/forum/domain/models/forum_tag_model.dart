import 'package:json_annotation/json_annotation.dart';

part 'forum_tag_model.g.dart';

@JsonSerializable()
class Tag {
  Tag({
    this.id,
    this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;

  Tag copyWith({
    int? id,
    String? name,
  }) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() => _$TagToJson(this);
}

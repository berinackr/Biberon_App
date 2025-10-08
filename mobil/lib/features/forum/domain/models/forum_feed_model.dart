import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forum_feed_model.g.dart';

@JsonSerializable()
class Feed {
  Feed({
    this.message,
    this.status,
    this.data,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'data')
  final List<Post>? data;

  Feed copyWith({
    String? message,
    String? status,
    List<Post>? data,
  }) =>
      Feed(
        message: message ?? this.message,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() => _$FeedToJson(this);
}

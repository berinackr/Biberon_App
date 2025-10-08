import 'package:biberon/core/type_defs.dart';
import 'package:flutter_quill/quill_delta.dart';

abstract class ForumApi {
  const ForumApi();

  // POST - /v1/forum/post
  /// Create a new post
  /* code */
  FutureVoid postContent(String title, Delta body, List<dynamic> tags);

  FutureVoid editPost(String id, String title, Delta body, List<dynamic> tags);
  // *GET - /v1/forum/feed
  /// Get feed. tags query for get feed for specific tag. key_id must have on
  /// pagination. for date based sorting date must be specified on pagination.
  /// For vote or comment based sorting count must be specified.
  /// Both date, key_id and count must be the latest fetched post properties
  /// one that you want to fetch after that post.
  /// {
  ///  required String orderWith,
  ///  required String orderBy,
  ///  String? keyId,
  ///  String? date,
  ///  int? count,
  ///  int? tag,
  /// }
  FutureFeed getForumFeed(
    String orderWith,
    String orderBy,
    String? keyId,
    String? date,
    int? count,
    int? tag,
  );

  // GET - /v1/forum/post/{id}
  /* code */
  FutureVoid getPost(String id);
  // *PUT - /v1/forum/post/{id}
  /* code */

  // *GET - /v1/forum/tags/popular
  /* code */

  // *GET - /v1/forum/bookmarks
  FutureFeed getBookmarkedPosts(String? createdAt, String? keyId);

  // PUT - /v1/forum/post/{id}/votes
  /* code */

  // DELETE - /v1/forum/post/{id}/votes
  /* code */

  // POST - /v1/forum/post/{id}/bookmark
  FutureVoid setPostBookmarked(String id);

  // DELETE - /v1/forum/post/{id}/bookmark
  FutureVoid removePostBookmarked(String id);

  // POST - /v1/forum/post/{id}/answer
  /* code */

  // GET - /v1/forum/post/{id}/answer
  /* code */

  // PUT - /v1/forum/post/{id}/answer/{answerId}
  /* code */

  // POST - /v1/forum/post/{id}/answer/{answerId}/correct
  /* code */

  // POST - /v1/forum/post/{id}/comment
  /* code */

  // GET - /v1/forum/post/{id}/comment
  /* code */

  // PUT - /v1/forum/post/{id}/comment/{commentId}
  /* code */

  // POST - /v1/forum/post/{id}/comment/{commentId}/votes
  /* code */

  // DELETE - /v1/forum/post/{id}/comment/{commentId}/votes
  /* code */
}

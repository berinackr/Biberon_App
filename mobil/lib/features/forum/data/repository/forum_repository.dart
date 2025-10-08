import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/forum/data/datasources/forum_api.dart';
import 'package:flutter_quill/quill_delta.dart';

class ForumRepository {
  const ForumRepository({
    required ForumApi forumApi,
  }) : _forumApi = forumApi;

  final ForumApi _forumApi;

  // Create forum post
  /* code */
  FutureVoid postContent({
    required String title,
    required Delta body,
    required List<dynamic> tags,
  }) =>
      _forumApi.postContent(title, body, tags);

  FutureVoid editPost({
    required String id,
    required String title,
    required Delta body,
    required List<dynamic> tags,
  }) {
    return _forumApi.editPost(id, title, body, tags);
  }

  // Get forum feed
  // Diğer api'ler için bunu örnek almayın.
  // Burada birden queryparameter var birbirine bağımlı oldukları için
  // null göndermemeliyiz daha iyi bir pattern kurmak yerine
  // şimdilik bu şekilde yazdım.
  FutureFeed getForumFeed({
    String orderWith = 'lastActivity',
    String orderBy = 'asc',
    String? keyId,
    String? date,
    int? count,
    int? tag,
  }) {
    return _forumApi.getForumFeed(
      orderWith,
      orderBy,
      keyId,
      date,
      count,
      tag,
    );
  }

  // get bookmarked Post
  FutureFeed getBookmarkedPosts({String? createdAt, String? keyId}) {
    return _forumApi.getBookmarkedPosts(createdAt, keyId);
  }

  // remove post bookmarked
  FutureVoid removePostBookmarked(String id) {
    return _forumApi.removePostBookmarked(id);
  }

  // set post bookmarked
  FutureVoid setPostBookmarked(String id) {
    return _forumApi.setPostBookmarked(id);
  }

  FutureVoid getPost(String id) {
    return _forumApi.getPost(id);
  }
}

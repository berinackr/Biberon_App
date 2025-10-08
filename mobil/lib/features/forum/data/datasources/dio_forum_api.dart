import 'package:biberon/common/network/network_exception.dart';
import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/forum/data/datasources/forum_api.dart';
import 'package:biberon/features/forum/domain/models/forum_feed_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:fpdart/fpdart.dart';

class DioForumApi extends ForumApi {
  DioForumApi({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  @override
  FutureFeed getForumFeed(
    String orderWith,
    String orderBy,
    String? keyId,
    String? date,
    int? count,
    int? tag,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'forum/feed',
        queryParameters: {
          'order_with': orderWith,
          'order_by': orderBy,
          if (keyId != null) 'key_id': keyId,
          if (date != null) 'date': date,
          if (count != null) 'count': count,
          if (tag != null) 'tag': tag,
        },
      );
      return right(
        Feed.fromJson(response.data!),
      );
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureFeed getBookmarkedPosts(String? createdAt, String? keyId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'forum/bookmarks',
        queryParameters: {
          if (createdAt != null) 'createdAt': createdAt,
          if (keyId != null) 'keyId': keyId,
        },
      );
      return right(
        Feed.fromJson(
          response.data!,
        ),
      );
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid removePostBookmarked(String id) async {
    try {
      await _dio.delete<Map<String, dynamic>>(
        'forum/post/$id/bookmark',
      );
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid setPostBookmarked(String id) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        'forum/post/$id/bookmark',
      );
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid postContent(String title, Delta body, List<dynamic> tags) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        'forum/post',
        data: {
          'title': title,
          'richText': body.toJson(),
          'tags': tags,
        },
      );
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid editPost(
    String id,
    String title,
    Delta body,
    List<dynamic> tags,
  ) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        'forum/post/$id',
        data: {
          'title': title,
          'richText': body.toJson(),
          'tags': tags,
        },
      );
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid getPost(String id) async {
    try {
      await _dio.get<Map<String, dynamic>>(
        'forum/post/$id',
      );
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }
}

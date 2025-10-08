import 'package:biberon/features/notification/notification.dart';

/// {@template notification_repository}
/// Nofitification repository
/// {@endtemplate}
class NotificationRepository {
  /// {@macro notification_repository}
  const NotificationRepository({
    required NotificationApi notificationApi,
  }) : _notificationApi = notificationApi;

  final NotificationApi _notificationApi;

  /// return the current token
  Future<String?> get token => _notificationApi.token;

  /// delete the current token
  Future<void> deleteToken() => _notificationApi.deleteToken();

  /// return the token stream
  Stream<String?> get tokenStream => _notificationApi.tokenStream;

  /// dispose the controller if exists one
  void dispose() => _notificationApi.dispose();
}

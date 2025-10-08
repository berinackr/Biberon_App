/// {@template notification_api}
/// Notification api
/// {@endtemplate}
abstract class NotificationApi {
  /// {@macro notification_api}
  const NotificationApi();

  /// Returns the fcm token
  Future<String?> get token;

  /// Creates a new fcm token
  Future<void> deleteToken();

  /// Returns the fcm token stream
  Stream<String?> get tokenStream;

  /// Dispose the controller if exists one
  void dispose();
}

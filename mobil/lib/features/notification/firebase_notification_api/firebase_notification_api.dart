import 'package:biberon/features/notification/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// {@template firebase_notification_api}
/// Firebase notification api
/// {@endtemplate}
class FirebaseNotificationApi extends NotificationApi {
  /// {@macro firebase_notification_api}
  FirebaseNotificationApi({
    required FirebaseMessaging firebaseMessaging,
  }) : _firebaseMessaging = firebaseMessaging;

  final FirebaseMessaging _firebaseMessaging;

  @override
  Future<String?> get token async {
    final fcmToken = await _firebaseMessaging.getToken();
    return fcmToken;
  }

  @override
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
  }

  @override
  Stream<String?> get tokenStream {
    return _firebaseMessaging.onTokenRefresh;
  }

  @override
  void dispose() {}
}

// ignore_for_file: cascade_invocations
import 'package:biberon/common/network/dio_client.dart';
import 'package:biberon/core/env.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/forum/data/datasources/dio_forum_api.dart';
import 'package:biberon/features/forum/data/repository/forum_repository.dart';
import 'package:biberon/features/local_storage/data/datasources/shared_preferences.dart';
import 'package:biberon/features/local_storage/data/repository/shared_prefences_repository.dart';
import 'package:biberon/features/notification/notification.dart';
import 'package:biberon/features/user/profile/data/datasources/dio_profile_api.dart';
import 'package:biberon/features/user/profile/data/repository/profile_repository.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Google Sign In
  getIt.registerSingleton(
    GoogleSignIn(
      serverClientId: Environment.googleServerClientKey,
    ),
  );
  // Logger Talker
  getIt.registerSingleton(TalkerFlutter.init());
  Bloc.observer = TalkerBlocObserver(
    talker: getIt<Talker>(),
  );

  // Dio
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  getIt.registerSingleton(
    PersistCookieJar(
      storage: FileStorage('$appDocPath/.cookies/'),
    ),
  );
  getIt.registerSingleton(CookieManager(getIt<PersistCookieJar>()));
  await AuthClient.initDio(
    talker: getIt<Talker>(),
    cookieManager: getIt<CookieManager>(),
  );

  getIt.registerLazySingleton(() => AuthClient.dio, instanceName: 'authClient');

  // Authentication Api
  getIt.registerSingleton(
    DioAuthenticationApi(
      dio: getIt<Dio>(instanceName: 'authClient'),
      googleSignIn: getIt<GoogleSignIn>(),
    ),
  );
  // Authentication Repository
  getIt.registerSingleton(
    AuthenticationRepository(
      authenticationApi: getIt<DioAuthenticationApi>(),
      talker: getIt<Talker>(),
    ),
  );

  await Client.initDio(
    authRepository: getIt<AuthenticationRepository>(),
    talker: getIt<Talker>(),
    cookieManager: getIt<CookieManager>(),
  );
  getIt.registerLazySingleton(() => Client.dio, instanceName: 'client');

  // Notification Api
  getIt.registerSingleton(
    FirebaseNotificationApi(
      firebaseMessaging: FirebaseMessaging.instance,
    ),
  );
  // Notification Repository
  getIt.registerSingleton(
    NotificationRepository(
      notificationApi: getIt<FirebaseNotificationApi>(),
    ),
  );

  await SharedPrefencesApi().init();

  // Local Storage Repository
  getIt.registerSingleton(
    SharedPrefencesApi.getInstance(),
  );

  getIt.registerSingleton(
    SharedPrefencesRepository(
      sharedPrefencesApi: getIt<SharedPrefencesApi>(),
      talker: getIt<Talker>(),
    ),
  );

  // Dio Profile Api
  getIt.registerSingleton(
    DioProfileApi(
      dio: getIt<Dio>(instanceName: 'client'),
    ),
  );

  // Profile Repository
  getIt.registerSingleton(
    ProfileRepository(
      profileApi: getIt<DioProfileApi>(),
    ),
  );

  // Dio Forum Api
  getIt.registerSingleton(
    DioForumApi(
      dio: getIt<Dio>(instanceName: 'client'),
    ),
  );

  // Forum Repository
  getIt.registerSingleton(
    ForumRepository(
      forumApi: getIt<DioForumApi>(),
    ),
  );
}

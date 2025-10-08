import 'package:biberon/bootstrap.dart';
import 'package:biberon/common/app/app.dart';
import 'package:biberon/core/di.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/forum/data/repository/forum_repository.dart';
import 'package:biberon/features/local_storage/data/repository/shared_prefences_repository.dart';
import 'package:biberon/features/notification/notification.dart';
import 'package:biberon/features/user/profile/data/repository/profile_repository.dart';
import 'package:biberon/firebase_options_stg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();

  await bootstrap(
    () => App(
      authenticationRepository: getIt<AuthenticationRepository>(),
      logger: getIt<Talker>(),
      notificationRepository: getIt<NotificationRepository>(),
      localStorageRepository: getIt<SharedPrefencesRepository>(),
      profileRepository: getIt<ProfileRepository>(),
      forumRepository: getIt<ForumRepository>(),
    ),
  );
}

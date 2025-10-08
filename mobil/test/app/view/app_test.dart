import 'package:biberon/common/app/app.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/domain/models/authentication_status.dart';
import 'package:biberon/features/forum/data/repository/forum_repository.dart';
import 'package:biberon/features/local_storage/data/repository/shared_prefences_repository.dart';
import 'package:biberon/features/notification/notification.dart';
import 'package:biberon/features/user/profile/data/repository/profile_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {
  @override
  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
  }

  @override
  Future<void> init() {
    return Future.value();
  }
}

class MockLogger extends Mock implements Talker {}

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockLocalStorageRepository extends Mock
    implements SharedPrefencesRepository {
  @override
  Future<bool> checkIsFirstTime() {
    return Future.value(true);
  }
}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockForumRepository extends Mock implements ForumRepository {}

void main() {
  final mockAuthenticationRepository = MockAuthenticationRepository();
  final mockLogger = MockLogger();
  final mockNotificationRepository = MockNotificationRepository();
  final mockLocalStorageRepository = MockLocalStorageRepository();
  final mockProfileRepository = MockProfileRepository();
  final mockForumRepository = MockForumRepository();
  group('App', () {
    testWidgets('renders with Roboto font', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: mockAuthenticationRepository,
          logger: mockLogger,
          notificationRepository: mockNotificationRepository,
          localStorageRepository: mockLocalStorageRepository,
          profileRepository: mockProfileRepository,
          forumRepository: mockForumRepository,
        ),
      );
      final textTheme = Theme.of(tester.element(find.byType(App))).textTheme;
      expect(
        textTheme.bodyMedium?.fontFamily,
        'Roboto',
      );
    });
  });
}

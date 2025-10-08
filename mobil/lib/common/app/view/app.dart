import 'package:biberon/common/app/app.dart';
import 'package:biberon/features/activity/activity.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/domain/models/authentication_status.dart';
import 'package:biberon/features/forum/data/repository/forum_repository.dart';
import 'package:biberon/features/forum/forum.dart';
import 'package:biberon/features/home/home.dart';
import 'package:biberon/features/local_storage/data/repository/shared_prefences_repository.dart';
import 'package:biberon/features/mybaby/mybaby.dart';
import 'package:biberon/features/notification/notification.dart';
import 'package:biberon/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:biberon/features/user/profile/data/repository/profile_repository.dart';
import 'package:biberon/features/user/profile/presentation/screens/babies/bloc/babies_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancies/bloc/pregnancies_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:biberon/features/user/profile/profile.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';

class App extends StatelessWidget {
  const App({
    required this.authenticationRepository,
    required this.logger,
    required this.notificationRepository,
    required this.localStorageRepository,
    required this.profileRepository,
    required this.forumRepository,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final Talker logger;
  final NotificationRepository notificationRepository;
  final SharedPrefencesRepository localStorageRepository;
  final ProfileRepository profileRepository;
  final ForumRepository forumRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => authenticationRepository,
        ),
        RepositoryProvider(
          create: (context) => logger,
        ),
        RepositoryProvider(
          create: (context) => notificationRepository,
        ),
        RepositoryProvider(
          create: (context) => localStorageRepository,
        ),
        RepositoryProvider(
          create: (context) => profileRepository,
        ),
        RepositoryProvider(
          create: (context) => forumRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              logger: logger,
            )..add(const AuthenticationSubscriptionRequested()),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => AppBloc(),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(
              logger: logger,
              notificationRepository: notificationRepository,
              authenticationRepository: authenticationRepository,
            )..add(const NotificationInit()),
          ),
          BlocProvider(
            create: (context) => OnboardingBloc(
              localStorageRepository: localStorageRepository,
              logger: logger,
            ),
          ),
          BlocProvider(
            create: (context) => HomeBloc(
              authenticationRepository: authenticationRepository,
              logger: logger,
            ),
          ),
          BlocProvider(
            create: (context) => ActivityBloc(),
          ),
          BlocProvider(
            create: (context) => MybabyBloc(),
          ),
          BlocProvider(
            create: (context) => PregnanciesBloc(
              profileRepository: profileRepository,
              logger: logger,
            ),
          ),
          BlocProvider(
            create: (context) => PregnancyBloc(
              profileRepository: profileRepository,
              logger: logger,
            ),
          ),
          BlocProvider(
            create: (context) => FeedBloc(
              forumRepository: forumRepository,
              logger: logger,
            ),
          ),
          BlocProvider(
            create: (context) => PostBloc(
              forumRepository: forumRepository,
              logger: logger,
            ),
          ),
          BlocProvider(
            create: (context) => BabyBloc(
              profileRepository: profileRepository,
              logger: logger,
            ),
          ),
          BlocProvider(
            create: (context) => BabiesBloc(
              logger: logger,
              profileRepository: profileRepository,
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final router = AppRouter.router(
      authenticationBloc: context.read<AuthenticationBloc>(),
    );

    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
      ],
      debugShowCheckedModeBanner: false,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      theme: FlexThemeData.light(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5D5FEF),
          primary: const Color(0xFF5D5FEF),
          secondary: const Color(0xFFFFA083),
        ),
        useMaterial3: true,
        useMaterial3ErrorColors: true,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        subThemesData: const FlexSubThemesData(
          inputDecoratorFillColor: Colors.transparent,
          inputDecoratorBackgroundAlpha: 0,
          inputDecoratorRadius: 6,
          inputDecoratorFocusedBorderWidth: 1.5,
          useTextTheme: true,
          outlinedButtonRadius: 4,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.background,
          outlinedButtonTextStyle: MaterialStatePropertyAll(
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          filledButtonRadius: 6,
          filledButtonTextStyle: MaterialStatePropertyAll(
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          textButtonTextStyle: MaterialStatePropertyAll(
            TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color.fromARGB(255, 132, 164, 184),
          secondary: Color(0xFFdeb3ae),
        ),
        useMaterial3: true,
        useMaterial3ErrorColors: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        subThemesData: const FlexSubThemesData(
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorFillColor: Colors.transparent,
          inputDecoratorBackgroundAlpha: 0,
          useTextTheme: true,
          filledButtonRadius: 20,
          filledButtonTextStyle: MaterialStatePropertyAll(
            TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: 'FilsonPro',
            ),
          ),
          textButtonTextStyle: MaterialStatePropertyAll(
            TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: 'FilsonPro',
            ),
          ),
        ),
      ),
      routerDelegate: router.routerDelegate,
      builder: (context, child) =>
          BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.unknown:
              break;
            case AuthenticationStatus.authenticated:
              context.read<AppBloc>().add(const AppRouteChanged('/home'));
              context.read<NotificationBloc>().add(
                    const NotificationInit(),
                  );
            case AuthenticationStatus.unauthenticated:
              context.read<AppBloc>().add(const AppRouteChanged('/sign-in'));
            case AuthenticationStatus.authenticatedButNotVerified:
              context
                  .read<AppBloc>()
                  .add(const AppRouteChanged('/verify-email'));
          }
        },
        child: child,
      ),
    );
  }
}

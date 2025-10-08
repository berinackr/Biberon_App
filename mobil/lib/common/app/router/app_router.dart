import 'package:biberon/common/app/app.dart';
import 'package:biberon/common/app/router/router.dart';
import 'package:biberon/common/bottom_navigation_bar/bottom_navigator_bar.dart';
import 'package:biberon/common/utils/listenable_stream.dart';
import 'package:biberon/common/widgets/loading_page.dart';
import 'package:biberon/features/activity/activity.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/domain/models/authentication_status.dart';
import 'package:biberon/features/authentication/presentation/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:biberon/features/authentication/presentation/screens/forgot_password/forget_password.dart';
import 'package:biberon/features/authentication/presentation/screens/verify/verify.dart';
import 'package:biberon/features/forum/data/repository/forum_repository.dart';
import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:biberon/features/forum/forum.dart';
import 'package:biberon/features/forum/presentation/screens/post/view/edit_post_page.dart';
import 'package:biberon/features/forum/presentation/screens/tag/view/view.dart';
import 'package:biberon/features/home/home.dart';
import 'package:biberon/features/local_storage/data/repository/shared_prefences_repository.dart';
import 'package:biberon/features/mybaby/mybaby.dart';
import 'package:biberon/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:biberon/features/onboarding/view/onboarding_page.dart';
import 'package:biberon/features/user/profile/data/repository/profile_repository.dart';
import 'package:biberon/features/user/profile/presentation/profiles_screen.dart';
import 'package:biberon/features/user/profile/presentation/screens/babies/bloc/babies_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/babies/view/babies_page.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/view/baby_page.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/bloc/mother_profile_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/view/mother_profile_page.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancies/bloc/pregnancies_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancies/view/pregnancies.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/view/pregnancy.dart';
import 'package:biberon/features/user/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class AppRouter {
  static GoRouter? _router;

  static GoRouter router({
    required AuthenticationBloc authenticationBloc,
    String? initialLocation,
  }) {
    if (_router != null) {
      return _router!;
    }
    final rootNavigatorKey = GlobalKey<NavigatorState>();
    final shellNavigatorHomeKey =
        GlobalKey<NavigatorState>(debugLabel: 'shellHome');
    final shellNavigatorBabyKey =
        GlobalKey<NavigatorState>(debugLabel: 'shellBaby');
    final shellNavigatorForumkey =
        GlobalKey<NavigatorState>(debugLabel: 'shellForum');
    final shellNavigatorEventKey =
        GlobalKey<NavigatorState>(debugLabel: 'shellEvent');

    _router = GoRouter(
      initialLocation: '/loading',
      navigatorKey: rootNavigatorKey,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNestedNavigation(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: shellNavigatorHomeKey,
              routes: [
                GoRoute(
                  path: '/home',
                  name: AppRoutes.home,
                  builder: (context, state) => BlocProvider(
                    create: (context) => HomeBloc(
                      authenticationRepository:
                          context.read<AuthenticationRepository>(),
                      logger: context.read<Talker>(),
                    ),
                    child: const HomePage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: shellNavigatorBabyKey,
              routes: [
                GoRoute(
                  path: '/mybaby',
                  name: 'mybaby',
                  builder: (context, state) {
                    return const MyBabyPage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: shellNavigatorForumkey,
              routes: [
                GoRoute(
                  path: '/forum',
                  name: AppRoutes.forum,
                  builder: (context, state) {
                    return BlocProvider(
                      create: (context) => FeedBloc(
                        forumRepository: context.read<ForumRepository>(),
                        logger: context.read<Talker>(),
                      )..add(const RefreshFeed()),
                      child: const FeedPage(),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: shellNavigatorEventKey,
              routes: [
                GoRoute(
                  path: '/activity',
                  name: 'activity',
                  builder: (context, state) {
                    return const ActivityPage();
                  },
                ),
              ],
            ),
          ],
        ),
        //onboarding
        GoRoute(
          path: '/onboarding',
          name: AppRoutes.onboarding,
          builder: (context, state) => BlocProvider(
            create: (context) => OnboardingBloc(
              localStorageRepository: context.read<SharedPrefencesRepository>(),
              logger: context.read<Talker>(),
            ),
            child: const OnboardingPage(),
          ),
        ),
        // signIn
        GoRoute(
          path: '/auth',
          name: AppRoutes.signUp,
          builder: (context, state) => BlocProvider(
            create: (context) => SignUpBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
              logger: context.read<Talker>(),
            ),
            child: const OnboardingPage(), //SignUpPage(), ------------------bu
          ),
          routes: [
            // signUp
            GoRoute(
              path: 'sign-in',
              name: AppRoutes.signIn,
              builder: (context, state) => BlocProvider(
                create: (context) => SignInBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>(),
                  logger: context.read<Talker>(),
                ),
                child: const SignInPage(),
              ),
            ),
            // forgetPassword
            GoRoute(
              path: 'forget-password',
              name: AppRoutes.forgetPassword,
              builder: (context, state) => BlocProvider(
                create: (context) => ForgetPasswordBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>(),
                  logger: context.read<Talker>(),
                ),
                child: const ForgetPasswordPage(),
              ),
            ),
          ],
        ),
        // verify
        GoRoute(
          path: '/verify',
          name: AppRoutes.verify,
          builder: (context, state) => BlocProvider(
            create: (context) => VerifyBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
              logger: context.read<Talker>(),
            ),
            child: const VerifyPage(),
          ),
        ),

        GoRoute(
          path: '/profiles-screen',
          name: AppRoutes.profilesScreen,
          builder: (context, state) => const ProfilesScreen(initialIndex: 1),
        ),
        // home

        GoRoute(
          path: '/mother-profile',
          name: AppRoutes.motherProfile,
          builder: (context, state) => BlocProvider(
            create: (context) => MotherProfileBloc(
              profileRepository: context.read<ProfileRepository>(),
              logger: context.read<Talker>(),
            )..add(const GetUserProfile()),
            child: const MotherProfilePage(),
          ),
        ),
        GoRoute(
          path: '/loading',
          name: AppRoutes.loading,
          builder: (context, state) {
            return const LoadingPage();
          },
        ),
        GoRoute(
          path: '/pregnancies',
          name: AppRoutes.pregnancies,
          builder: (context, state) => BlocProvider(
            create: (context) => PregnanciesBloc(
              profileRepository: context.read<ProfileRepository>(),
              logger: context.read<Talker>(),
            )..add(
                const FetchPregnancies(),
              ),
            child: const PregnanciesPage(),
          ),
          routes: [
            GoRoute(
              path: 'pregnancy',
              name: AppRoutes.pregnancy,
              builder: (context, state) {
                final pregnancyId = state.uri.queryParameters['pregnancyId'];
                final id = pregnancyId != null ? int.parse(pregnancyId) : null;
                return BlocProvider(
                  create: (context) => PregnancyBloc(
                    profileRepository: context.read<ProfileRepository>(),
                    logger: context.read<Talker>(),
                  )..add(FetchPregnancy(id)),
                  child: const PregnancyPage(),
                );
              },
            ),
          ],
        ),

        // post question
        ShellRoute(
          routes: [
            GoRoute(
              path: '/post',
              name: AppRoutes.post,
              builder: (context, state) {
                return const PostPage();
              },
              routes: [
                GoRoute(
                  path: 'select-tag',
                  name: AppRoutes.selectTag,
                  builder: (context, state) {
                    return const TagSelectionPage();
                  },
                ),
              ],
            ),
          ],
          builder: (context, state, child) {
            return BlocProvider(
              create: (context) => PostBloc(
                forumRepository: context.read<ForumRepository>(),
                logger: context.read<Talker>(),
              ),
              child: child,
            );
          },
        ),

        GoRoute(
          path: '/edit-post',
          name: AppRoutes.editPost,
          builder: (context, state) {
            final selectedPost = state.extra! as Post;
            return BlocProvider(
              create: (context) => PostBloc(
                forumRepository: context.read<ForumRepository>(),
                logger: context.read<Talker>(),
              ),
              child: EditPostPage(selectedPost: selectedPost),
            );
          },
        ),
        // /babies
        GoRoute(
          path: '/babies',
          name: AppRoutes.babies,
          builder: (context, state) => BlocProvider(
            create: (context) => BabiesBloc(
              profileRepository: context.read<ProfileRepository>(),
              logger: context.read<Talker>(),
            )..add(
                const BabiesEventLoadBabies(),
              ),
            child: const BabiesPage(),
          ),
          routes: [
            GoRoute(
              path: 'baby',
              name: AppRoutes.baby,
              builder: (context, state) {
                final babyId = state.uri.queryParameters['babyId'];
                final id = babyId != null ? int.parse(babyId) : null;
                return BlocProvider(
                  create: (context) => BabyBloc(
                    profileRepository: context.read<ProfileRepository>(),
                    logger: context.read<Talker>(),
                  )..add(BabyEventLoad(id)),
                  child: const BabyPage(),
                );
              },
            ),
          ],
        ),
      ],
      refreshListenable: ListenableStream(authenticationBloc.stream),
      redirect: (context, state) async {
        final isSignIn = state.fullPath == '/auth/sign-in';
        final isRegistering = state.fullPath == '/auth';
        final isForgotPassword = state.fullPath == '/auth/forget-password';
        final isVerifiedScreen = state.fullPath == '/verify';
        final isSplashScreen = state.fullPath == '/loading';
        final isAuthInitiliazed =
            authenticationBloc.state.status != AuthenticationStatus.unknown;
        if (!isAuthInitiliazed) {
          return null;
        }
        final isOnboardingShowedBefore =
            await context.read<SharedPrefencesRepository>().checkIsFirstTime();
        final isNotVerified = authenticationBloc.state.status ==
            AuthenticationStatus.authenticatedButNotVerified;
        final isAuthenticated = authenticationBloc.state.status ==
            AuthenticationStatus.authenticated;

        if (!isNotVerified && isVerifiedScreen) {
          return '/home';
        }

        if (isNotVerified && !isVerifiedScreen) {
          return '/verify';
        }

        if (isAuthenticated && (isSignIn || isRegistering || isSplashScreen)) {
          return '/home';
        }

        if (!isAuthenticated && isForgotPassword) {
          return '/auth/forget-password';
        }

        if (!isAuthenticated &&
            !isSignIn &&
            !isRegistering & !isVerifiedScreen) {
          if (isOnboardingShowedBefore) {
            return '/auth';
          } else {
            return '/onboarding';
          }
        }
        return null;
      },
    );

    return _router!;
  }
}

import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/data/models/forgot_password_post_model.dart';
import 'package:biberon/features/authentication/data/models/login_post_model.dart';
import 'package:biberon/features/authentication/data/models/signup_post_model.dart';
import 'package:biberon/features/authentication/data/models/verify_post_model.dart';
import 'package:biberon/features/authentication/domain/models/authentication_status.dart';
import 'package:biberon/features/authentication/domain/models/user_model.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// {@template authentication_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  const AuthenticationRepository({
    required AuthenticationApi authenticationApi,
    required Talker talker,
  })  : _authenticationApi = authenticationApi,
        _talker = talker;

  final AuthenticationApi _authenticationApi;
  final Talker _talker;

  /// Returns the user data, if there is a logged in user, otherwise null
  UserModel? get user => _authenticationApi.user;

  /// Get Current User
  FutureVoid getCurrentUser() => _authenticationApi.getCurrentUser();

  /// Init the authentication status
  Future<void> init() async {
    try {
      final result = await _authenticationApi.getCurrentUser();
      if (result.isLeft()) {
        final result = await _authenticationApi.refreshTokens();
        if (result.isLeft()) {
          _talker.error('Error getting current user', result.getLeft());
        } else {
          _talker.info('User refreshed');
          await _authenticationApi.getCurrentUser();
        }
      } else {
        _talker.info('User authenticated');
      }
      FlutterNativeSplash.remove();
    } catch (e, stk) {
      _talker.error(e.toString(), stk);
    }
  }

  /// Stream of AuthStatus
  Stream<AuthenticationStatus> get status =>
      _authenticationApi.status.asBroadcastStream();

  /// Creates a new user
  FutureVoid signUp(SignupPostModel signupPostModel) =>
      _authenticationApi.signUp(signupPostModel);

  /// Creates a new user with Google
  FutureVoid signInWithGoogle() => _authenticationApi.signInWithGoogle();

  /// Log in an existing user
  FutureVoid signIn(LoginPostModel signIn) => _authenticationApi.signIn(signIn);

  /// Changes the name of the current user
  Future<void> changeName({required String name}) =>
      _authenticationApi.changeName(name: name);

  /// Changes the email of the current user
  Future<void> changeEmail({required String email}) =>
      _authenticationApi.changeEmail(email: email);

  /// Signs out the current user, if there is a logged in user.
  FutureVoid signOut() => _authenticationApi.signOut();

  /// Updates current users fcm token
  FutureVoid updateFCMToken({required String token}) =>
      _authenticationApi.updateFCMToken(token: token);

  /// Refresh tokens
  FutureVoid refreshTokens() => _authenticationApi.refreshTokens();

  FutureResponse sendVerificationEmail() =>
      _authenticationApi.sendVerificationEmail();

  FutureVoid verifyEmail(VerifyPostModel verifyPostModel) =>
      _authenticationApi.verifyEmail(verifyPostModel);

  FutureResponse sendForgotPasswordEmail(
    ForgotPasswordPostModel forgotPasswordPostModel,
  ) =>
      _authenticationApi.sendForgotPasswordEmail(forgotPasswordPostModel);

  /// Dispose the controller if exists one
  void dispose() => _authenticationApi.dispose();
}

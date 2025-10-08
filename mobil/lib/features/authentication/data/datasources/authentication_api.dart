import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/authentication/data/models/forgot_password_post_model.dart';
import 'package:biberon/features/authentication/data/models/login_post_model.dart';
import 'package:biberon/features/authentication/data/models/signup_post_model.dart';
import 'package:biberon/features/authentication/data/models/verify_post_model.dart';
import 'package:biberon/features/authentication/domain/models/authentication_status.dart';
import 'package:biberon/features/authentication/domain/models/user_model.dart';

/// {@template authentication_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class AuthenticationApi {
  /// {@macro authentication_api}
  const AuthenticationApi();

  /// Returns the user data, if there is a logged in user, otherwise null
  UserModel? get user;

  /// Get Current User
  FutureVoid getCurrentUser();

  /// Stream of AuthStatus
  Stream<AuthenticationStatus> get status;

  /// Creates a new user
  FutureVoid signUp(SignupPostModel signupPostModel);

  /// Creates a new user with Google
  FutureVoid signInWithGoogle();

  /// Log in an existing user
  FutureVoid signIn(LoginPostModel signIn);

  /// Changes the name of the current user
  Future<void> changeName({required String name});

  /// Changes the email of the current user
  Future<void> changeEmail({required String email});

  /// Signs out the current user, if there is a logged in user.
  FutureVoid signOut();

  /// Updates current users fcm token
  FutureVoid updateFCMToken({required String token});

  /// Refreshes tokens
  FutureVoid refreshTokens();

  /// Verify email
  FutureVoid verifyEmail(VerifyPostModel verifyPostModel);

  /// Sends a new verification email
  FutureResponse sendVerificationEmail();

  /// Sends a password reset email
  FutureResponse sendForgotPasswordEmail(
    ForgotPasswordPostModel forgotPasswordPostModel,
  );

  /// Dispose the controller if exists one
  void dispose();
}

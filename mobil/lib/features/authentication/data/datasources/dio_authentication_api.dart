import 'dart:async';

import 'package:biberon/common/errors/exception.dart';
import 'package:biberon/common/models/models.dart';
import 'package:biberon/common/network/network_exception.dart';
import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/data/models/forgot_password_post_model.dart';
import 'package:biberon/features/authentication/data/models/login_post_model.dart';
import 'package:biberon/features/authentication/data/models/signup_post_model.dart';
import 'package:biberon/features/authentication/data/models/verify_post_model.dart';
import 'package:biberon/features/authentication/domain/models/authentication_failure.dart';
import 'package:biberon/features/authentication/domain/models/authentication_status.dart';
import 'package:biberon/features/authentication/domain/models/login_model.dart';
import 'package:biberon/features/authentication/domain/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// {@template api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class DioAuthenticationApi extends AuthenticationApi {
  /// {@macro api}
  DioAuthenticationApi({required Dio dio, required GoogleSignIn googleSignIn})
      : _dio = dio,
        _googleSignIn = googleSignIn,
        currentUser = null;

  final Dio _dio;
  final GoogleSignIn _googleSignIn;
  final _statusStreamController = StreamController<AuthenticationStatus>();

  /// The current user
  UserModel? currentUser;

  @override
  UserModel? get user {
    return currentUser;
  }

  @override
  FutureVoid getCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('auth/me');
      if (response.statusCode == 200) {
        final data = UserModel.fromJson(response.data!);
        currentUser = data;
        if (data.emailVerified) {
          _statusStreamController.add(AuthenticationStatus.authenticated);
        } else {
          _statusStreamController
              .add(AuthenticationStatus.authenticatedButNotVerified);
        }
      }
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  Stream<AuthenticationStatus> get status async* {
    if (user != null) {
      if (user!.emailVerified) {
        yield AuthenticationStatus.authenticated;
      } else {
        yield AuthenticationStatus.authenticatedButNotVerified;
      }
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _statusStreamController.stream;
  }

  @override
  FutureVoid signUp(SignupPostModel signupPostModel) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'auth/email/new',
        data: signupPostModel.toJson(),
      );
      if (response.statusCode == 201) {
        final data = LoginModel.fromJson(response.data!);
        currentUser = data.user;
        if (data.user.emailVerified) {
          _statusStreamController.add(AuthenticationStatus.authenticated);
        } else {
          _statusStreamController
              .add(AuthenticationStatus.authenticatedButNotVerified);
        }
      }
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AppException(message: 'Google ile giriş başarısız oldu');
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw AppException(message: 'Google ile giriş başarısız oldu');
      }
      final response = await _dio.post<Map<String, dynamic>>(
        'auth/google',
        data: {
          'idToken': idToken,
        },
      );
      if (response.statusCode == 201 && response.data != null) {
        final loginResponse = LoginModel.fromJson(
          response.data!,
        );
        currentUser = loginResponse.user;
      }
      _statusStreamController.add(AuthenticationStatus.authenticated);
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    } on AppException catch (e, stk) {
      return left(AppException(message: e.message, layer: stk));
    }
  }

  @override
  FutureVoid signIn(LoginPostModel signIn) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'auth/email',
        data: signIn.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201 && response.data != null) {
        final loginResponse = LoginModel.fromJson(
          response.data!,
        );
        currentUser = loginResponse.user;
        if (loginResponse.user.emailVerified) {
          _statusStreamController.add(AuthenticationStatus.authenticated);
        } else {
          _statusStreamController
              .add(AuthenticationStatus.authenticatedButNotVerified);
        }
      }

      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid signOut() async {
    try {
      await _dio.delete<void>('auth/session');
      await _googleSignIn.signOut();
      currentUser = null;
      _statusStreamController.add(AuthenticationStatus.unauthenticated);
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  Future<void> changeName({required String name}) async {
    try {
      // TODO(av-erencelik): implement change name
    } catch (e) {
      throw AuthenticationFailure(message: e.toString());
    }
  }

  @override
  Future<void> changeEmail({required String email}) async {
    try {
      // TODO(av-erencelik): implement change email
    } catch (e) {
      throw AuthenticationFailure(message: e.toString());
    }
  }

  @override
  FutureVoid updateFCMToken({required String token}) async {
    try {
      // TODO(av-erencelik): implement update FCM token
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid refreshTokens() async {
    try {
      await _dio.post<void>('auth/session');
      return right(null);
    } on DioException catch (e, stk) {
      if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == 401) {
        currentUser = null;
        _statusStreamController.add(AuthenticationStatus.unauthenticated);
      }
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid verifyEmail(VerifyPostModel verifyPostModel) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'auth/verify',
        data: verifyPostModel.toJson(),
      );
      if (response.statusCode == 201) {
        final verifyResponse = LoginModel.fromJson(response.data!);
        currentUser = verifyResponse.user;
        _statusStreamController.add(AuthenticationStatus.authenticated);
      }
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureResponse sendVerificationEmail() async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        'auth/verify',
      );
      final data = ResponseModel.fromJson(response.data!);
      return right(data);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureResponse sendForgotPasswordEmail(
    ForgotPasswordPostModel forgotPasswordPostModel,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'users/password',
        data: forgotPasswordPostModel.toJson(),
      );
      final data = ResponseModel.fromJson(response.data!);
      return right(data);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  void dispose() => _statusStreamController.close();
}

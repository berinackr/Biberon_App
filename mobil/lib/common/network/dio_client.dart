import 'package:biberon/core/env.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Client {
  static late Dio dio;

  static Future<void> initDio({
    required AuthenticationRepository authRepository,
    required Talker talker,
    required CookieManager cookieManager,
  }) async {
    dio = Dio(
      BaseOptions(
        // ignore: avoid_redundant_argument_values
        baseUrl: Environment.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(cookieManager);
    dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
        ),
        talker: talker,
      ),
    );
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final result = await authRepository.refreshTokens();
            await result.fold(
              (l) => null,
              (r) async {
                final opts = Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                );
                final cloneReq = await dio.request<Map<String, dynamic>>(
                  error.requestOptions.path,
                  options: opts,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                return handler.resolve(cloneReq);
              },
            );
          }
          return handler.reject(error);
        },
      ),
    );
  }
}

class AuthClient {
  static late Dio dio;

  static Future<void> initDio({
    required Talker talker,
    required CookieManager cookieManager,
  }) async {
    dio = Dio(
      BaseOptions(
        // ignore: avoid_redundant_argument_values
        baseUrl: Environment.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(cookieManager);
    dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
        ),
        talker: talker,
      ),
    );
  }
}

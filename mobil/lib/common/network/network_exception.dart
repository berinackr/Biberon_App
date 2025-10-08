import 'package:biberon/common/errors/exception.dart';
import 'package:biberon/common/models/response_error_model.dart';
import 'package:biberon/core/app_strings.dart';
import 'package:dio/dio.dart';

class NetworkException extends AppException {
  NetworkException.fromDioError(DioException dioException, StackTrace stk)
      : super(layer: stk) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = AppString.cancelRequest;
      case DioExceptionType.connectionTimeout:
        message = AppString.connectionTimeout;
      case DioExceptionType.receiveTimeout:
        message = AppString.receiveTimeout;
      case DioExceptionType.sendTimeout:
        message = AppString.sendTimeout;
      case DioExceptionType.unknown:
        message = AppString.unknownError;
      case DioExceptionType.badResponse:
        message = _handleResponseError(
          dioException.response,
        );
      case DioExceptionType.badCertificate:
        message = AppString.badCertificate;
      case DioExceptionType.connectionError:
        message = AppString.socketException;
    }
  }

  String _handleResponseError(Response<dynamic>? response) {
    if (response != null) {
      switch (response.statusCode) {
        case 500:
          return AppString.internalServerError;
        default:
          final data = ResponseErrorModel.fromJson(
            response.data as Map<String, dynamic>,
          );
          return data.message;
      }
    }
    return AppString.unknownError;
  }
}

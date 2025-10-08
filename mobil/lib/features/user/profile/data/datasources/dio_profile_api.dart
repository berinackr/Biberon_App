import 'package:biberon/common/network/network_exception.dart';
import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/user/profile/data/datasources/profile_api.dart';
import 'package:biberon/features/user/profile/data/models/models.dart';
import 'package:biberon/features/user/profile/domain/models/models.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class DioProfileApi extends ProfileApi {
  DioProfileApi({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  @override
  FutureProfile getUserProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('users/profile');
      return right(ProfileModel.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureBaby addBaby({required BabyPostModel babyPostModel}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'users/baby',
        data: babyPostModel.toJson(),
      );
      return right(Baby.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FuturePregnancy addPregnancy({
    required PregnancyPostModel pregnancyPostModel,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'users/pregnancy',
        data: pregnancyPostModel,
      );
      return right(Pregnancy.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid deleteBaby({required int babyId}) async {
    try {
      await _dio.delete<Map<String, dynamic>>(
        'users/baby/$babyId',
      );
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureVoid deletePregnancy({required int pregnancyId}) async {
    try {
      await _dio.delete<Map<String, dynamic>>(
        'users/pregnancy/$pregnancyId',
        //queryParameters: {'id': pregnancyId},
      );
      return right(null);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FuturePregnancy getActivePregnancy({required bool includeFetuses}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'users/pregnancy/active',
        queryParameters: {'includeFetuses': includeFetuses},
      );
      return right(Pregnancy.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureBabies getBabies({String order = 'asc', int page = 1}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'users/baby',
        queryParameters: {'order': order, 'page': page},
      );
      //Model oluşturmak yerine doğrudan jsondan List of baby'e çevirdim.
      final data = response.data!['data'] as List;
      final babies =
          data.map((e) => Baby.fromJson(e as Map<String, dynamic>)).toList();
      return right(babies);
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureBaby getBaby({required int babyId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'users/baby/$babyId',
      );
      return right(Baby.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FuturePregnancies getPregnancies({
    String order = 'asc',
    int page = 1,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'users/pregnancy',
        queryParameters: {'order': order, 'page': page},
      );
      //Model oluşturmak yerine doğrudan jsondan List of pregnancy'e çevirdim.
      final data = response.data!['data'] as List;
      final pregnancies = data
          .map((e) => Pregnancy.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(
        pregnancies,
      );
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FuturePregnancy getPregnancy({
    required int pregnancyId,
    required bool includeFetuses,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'users/pregnancy/$pregnancyId',
        queryParameters: {
          //'id': pregnancyId,
          'include_fetuses': includeFetuses,
        },
      );
      return right(Pregnancy.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureBaby updateBaby({
    required int babyId,
    required BabyPostModel babyPostModel,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        'users/baby/$babyId',
        data: babyPostModel.toJson(),
      );
      return right(Baby.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureFetus updateFetus({
    required int fetusId,
    required FetusPostModel fetus,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        'users/pregnancy/fetus/$fetusId',
        //queryParameters: {'id': fetusId},
        data: fetus.toJson(),
      );
      return right(Fetus.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FuturePregnancy updatePregnancy({
    required int pregnancyId,
    required PregnancyPostModel pregnancyPostModel,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        'users/pregnancy/$pregnancyId',
        //queryParameters: {'id': pregnancyId},
        data: pregnancyPostModel.toJson(),
      );
      return right(Pregnancy.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FutureProfile updateUserProfile({
    required UpdateProfilePostModel updateProfilePostModel,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        'users/profile',
        data: updateProfilePostModel.toJson(),
      );
      return right(ProfileModel.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }

  @override
  FuturePregnancy updateActivePregnancy({
    required DateTime birthDate,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        'users/pregnancy/active',
        data: {'birthDate': birthDate.toIso8601String()},
      );
      return right(Pregnancy.fromJson(response.data!));
    } on DioException catch (e, stk) {
      return left(NetworkException.fromDioError(e, stk));
    }
  }
}

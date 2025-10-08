import 'package:biberon/core/type_defs.dart';
import 'package:biberon/features/local_storage/data/datasources/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SharedPrefencesRepository {
  const SharedPrefencesRepository({
    required SharedPrefencesApi sharedPrefencesApi,
    required Talker talker,
  })  : _sharedPrefencesApi = sharedPrefencesApi,
        _talker = talker;

  final SharedPrefencesApi _sharedPrefencesApi;
  final Talker _talker;
  static bool? isFirstTime;

  FutureVoid init() async => _sharedPrefencesApi.init();

  Future<bool> checkIsFirstTime() async {
    if (isFirstTime != null) {
      return isFirstTime!;
    }
    _talker.info('checkIsFirstTime');
    final result = _sharedPrefencesApi.getBool('isFirstTime');
    isFirstTime = result;
    return result;
  }

  FutureVoid setFirstTime() async =>
      _sharedPrefencesApi.setBool('isFirstTime', value: true);
}

import 'package:biberon/common/errors/errors.dart';
import 'package:biberon/core/type_defs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences paketi kullanılarak
/// cihaz hafızasında veri saklamak için kullanlır.
/// Constructor metodu private olduğu için bu sınıftan sadece
/// bir nesne üretilebilir.
/// Bu repository'den bir nesne üretmek için
///  `SharedPrefencesApi.getInstance()` kullanılır.
/// Her seferinde aynı nesneyi döner.
/// Örnek: bir string veri yazmak:
/// ```dart
/// final local = SharedPrefencesApi.getInstance();
/// local.storage.setString('key', 'value');
/// ```
/// Örnek: bir string veri okumak:
/// ```dart
/// final local = SharedPrefencesApi.getInstance();
/// final value = local.storage.getString('key');
/// ```
/// NOT: isOnboardingShowedBefore değeri önceden atanmıştır.
/// Bu değer onboarding ekranının gösterilip gösterilmediğini kontrol etmek için
/// kullanılır. Eğer bu değer false ise onboarding ekranı gösterilir, true ise
/// gösterilmez. Lütfen bu anahtara atama yaparken dikkat edin.
class SharedPrefencesApi {
  factory SharedPrefencesApi() {
    return _instance;
  }

  SharedPrefencesApi._internal();

  static final SharedPrefencesApi _instance = SharedPrefencesApi._internal();
  late SharedPreferences _prefs;

  FutureVoid init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      return right(null);
    } catch (e, stk) {
      return left(AppException(message: e.toString(), layer: stk));
    }
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  FutureVoid setBool(String key, {required bool value}) async {
    try {
      await _prefs.setBool(key, value);
      return right(null);
    } catch (e, stk) {
      return left(AppException(message: e.toString(), layer: stk));
    }
  }

  SharedPreferences get storage => _prefs;

  static SharedPrefencesApi getInstance() {
    return _instance;
  }
}

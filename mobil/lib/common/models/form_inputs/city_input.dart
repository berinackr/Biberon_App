import 'package:biberon/common/data/cities_of_turkey.dart';
import 'package:biberon/common/models/models.dart';

enum CityInputValidationError { invalid }

class CityInput
    extends FormzInputWithErrorMessage<String, CityInputValidationError> {
  const CityInput.pure() : super.pure('');
  const CityInput.dirty([super.value = '']) : super.dirty();

  @override
  CityInputValidationError? validator(String value) {
    if (!citiesOfTurkey.contains(value.trim())) {
      return CityInputValidationError.invalid;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == CityInputValidationError.invalid) {
      return 'Lütfen geçerli bir şehir seçiniz';
    }
    return null;
  }
}

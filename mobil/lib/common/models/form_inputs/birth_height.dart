import 'package:formz/formz.dart';

enum BirthHeightValidationError { invalid }

class BirthHeight extends FormzInput<int?, BirthHeightValidationError> {
  const BirthHeight.pure() : super.pure(null);
  const BirthHeight.dirty([super.value]) : super.dirty();

  @override
  BirthHeightValidationError? validator(int? value) {
    if (value != null && (value <= 10 || value >= 75)) {
      return BirthHeightValidationError.invalid;
    }
    return null;
  }

  String? get errorMessage {
    if (error == BirthHeightValidationError.invalid) {
      return 'Bebeğinizin doğum boyu 10 ile 75 cm arasında olmalıdır.';
    }
    return null;
  }
}

import 'package:formz/formz.dart';

enum BirthWeightValidationError { invalid }

class BirthWeight extends FormzInput<int?, BirthWeightValidationError> {
  const BirthWeight.pure() : super.pure(null);
  const BirthWeight.dirty([super.value]) : super.dirty();

  @override
  BirthWeightValidationError? validator(int? value) {
    if (value != null && value <= 0) {
      return BirthWeightValidationError.invalid;
    }
    return null;
  }

  String? get errorMessage {
    if (error == BirthWeightValidationError.invalid) {
      return 'Bebeğinizin doğum ağırlığı 0 gramdan düşük olamaz.';
    }
    return null;
  }
}

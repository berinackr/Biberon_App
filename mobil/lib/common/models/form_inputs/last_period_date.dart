import 'package:formz/formz.dart';

enum LastPeriodDateValidationError {
  invalid,
  big,
  small,
}

class LastPeriodDate
    extends FormzInput<DateTime?, LastPeriodDateValidationError> {
  const LastPeriodDate.pure() : super.pure(null);
  const LastPeriodDate.dirty(super.value) : super.dirty();

  @override
  LastPeriodDateValidationError? validator(DateTime? value) {
    if (value == null) {
      return LastPeriodDateValidationError.invalid;
    }
    return null;
  }

  String? get errorMessage {
    if (error == LastPeriodDateValidationError.invalid) {
      return 'Geçerli bir son adet tarihi giriniz.';
    } else if (error == LastPeriodDateValidationError.big) {
      return 'Şimdiki tarihten büyük bir tarih giremezsiniz.';
    } else if (error == LastPeriodDateValidationError.small) {
      return 'Şimdiki tarihten 280 gün önceki bir tarih giremezsiniz.';
    }
    return null;
  }
}

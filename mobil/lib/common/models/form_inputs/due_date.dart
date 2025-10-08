import 'package:formz/formz.dart';

enum DueDateValidationError {
  invalid,
  big,
  small,
}

class DueDate extends FormzInput<DateTime?, DueDateValidationError> {
  const DueDate.pure() : super.pure(null);
  const DueDate.dirty(super.value) : super.dirty();

  @override
  DueDateValidationError? validator(DateTime? value) {
    if (value == null) {
      return DueDateValidationError.invalid;
    }
    // if (value.isBefore(DateTime.now())) {
    //   return DueDateValidationError.small;
    // }
    // if (value.isAfter(DateTime.now().add(const Duration(days: 280)))) {
    //   return DueDateValidationError.big;
    // }
    return null;
  }

  String? get errorMessage {
    if (error == DueDateValidationError.invalid) {
      return 'Geçerli bir tahmini doğum tarihi giriniz.';
    } else if (error == DueDateValidationError.small) {
      return 'Şimdiki tarihten küçük bir tarih giremezsiniz.';
    } else if (error == DueDateValidationError.big) {
      return 'Beklenen hamilelik tarihi 280 günden fazla olamaz.';
    }
    return null;
  }
}

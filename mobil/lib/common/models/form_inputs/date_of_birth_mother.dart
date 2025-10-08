import 'package:biberon/common/models/models.dart';

enum DateOfBirthValidationError { invalid, adultOnly }

class DateOfBirthMother
    extends FormzInputWithErrorMessage<DateTime?, DateOfBirthValidationError> {
  const DateOfBirthMother.pure() : super.pure(null);
  const DateOfBirthMother.dirty([super.value]) : super.dirty();

  @override
  DateOfBirthValidationError? validator(DateTime? value) {
    final today = DateTime.now();
    if (value != null) {
      if (value.isAfter(today)) {
        return DateOfBirthValidationError.invalid;
      } else if (value.microsecond >
          DateTime(
            DateTime.now().year - 18,
            DateTime.now().month,
            DateTime.now().day,
          ).microsecond) {
        return DateOfBirthValidationError.adultOnly;
      }
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == DateOfBirthValidationError.invalid) {
      return 'Geçerli bir tarih giriniz';
    } else if (error == DateOfBirthValidationError.adultOnly) {
      return '18 yaşından küçükler kayıt olamaz';
    }

    return null;
  }
}

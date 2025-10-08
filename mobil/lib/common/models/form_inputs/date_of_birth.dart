import 'package:formz/formz.dart';

enum DateOfBirthValidationError { invalid, isAfterNow, babiesOnly }

// const değer olarak bu günün tarihi atılmalı
class DateOfBirth extends FormzInput<DateTime?, DateOfBirthValidationError> {
  const DateOfBirth.pure() : super.pure(null);
  const DateOfBirth.dirty([super.value]) : super.dirty();

  @override
  DateOfBirthValidationError? validator(DateTime? value) {
    if (value == null) {
      return DateOfBirthValidationError.invalid;
    }
    // Muhtemelen widget önleyecektir ancak yine de ekledim.
    if (value.isAfter(DateTime.now())) {
      return DateOfBirthValidationError.isAfterNow;
    }
    // TODO(umutakpinar): Bu kontrol yapılmalı mı?
    // Eğer yapılacaksa backend 2 yaşından büyük çocukları oto silip mail atmalı
    // Kullanıcı önceden kaydettiği ancak an itibariyle
    // 2 yaşını doldurdmuş bir çocuğun bilgileirni güncellemek
    // istediğinde doğum tarihini kabul etmeyecek
    if (DateTime.now().difference(value).inDays > 730) {
      return DateOfBirthValidationError.babiesOnly;
    }
    return null;
  }

  String? get getErrorMessage {
    if (error == DateOfBirthValidationError.invalid) {
      return 'Doğum tarihi boş bırakılamaz';
    } else if (error == DateOfBirthValidationError.isAfterNow) {
      return 'Geçerli bir doğum tarihi seçiniz';
    } else if (error == DateOfBirthValidationError.babiesOnly) {
      return 'Uygulamamız 2 yaşından büyük çocuklarınız için uygun değildir.';
    }
    return null;
  }
}

import 'package:biberon/common/models/models.dart';

enum PasswordValidationError { empty, short, long }

class Password
    extends FormzInputWithErrorMessage<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.trim().isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.trim().length < 8) {
      return PasswordValidationError.short;
    } else if (value.trim().length > 64) {
      return PasswordValidationError.long;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == PasswordValidationError.empty) {
      return 'Şifre kısmı boş bırakılamaz';
    } else if (error == PasswordValidationError.short) {
      return 'Şifreniz en az 8 karakterden oluşmalıdır';
    } else if (error == PasswordValidationError.long) {
      return 'Şifreniz en fazla 64 karakterden oluşmalıdır';
    }
    return null;
  }
}

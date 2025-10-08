import 'package:biberon/common/models/models.dart';
import 'package:email_validator/email_validator.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInputWithErrorMessage<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (value.trim().isEmpty) {
      return EmailValidationError.empty;
    } else if (EmailValidator.validate(value.trim()) == false) {
      return EmailValidationError.invalid;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == EmailValidationError.empty) {
      return 'Email kısmı boş bırakılamaz';
    } else if (error == EmailValidationError.invalid) {
      return 'Geçerli bir email adresi giriniz';
    }
    return null;
  }
}

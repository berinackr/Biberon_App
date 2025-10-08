import 'package:formz/formz.dart';

enum CodeValidationError { empty, invalidlength }

class Code extends FormzInput<String, CodeValidationError> {
  const Code.pure() : super.pure('');
  const Code.dirty([super.value = '']) : super.dirty();

  @override
  CodeValidationError? validator(String value) {
    if (value.trim().isEmpty) {
      return CodeValidationError.empty;
    } else if (value.trim().length != 6) {
      return CodeValidationError.invalidlength;
    }
    return null;
  }

  String? get errorMessage {
    if (error == CodeValidationError.empty) {
      return 'Kod kısmı boş bırakılamaz';
    } else if (error == CodeValidationError.invalidlength) {
      return 'Kod 6 karakterden oluşmalıdır';
    }
    return null;
  }
}

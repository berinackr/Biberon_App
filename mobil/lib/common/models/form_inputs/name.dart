import 'package:biberon/common/models/models.dart';

enum NameValidationError { empty, short, long }

class Name extends FormzInputWithErrorMessage<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    if (value.trim().isEmpty) {
      return NameValidationError.empty;
    } else if (value.trim().length < 2) {
      return NameValidationError.short;
    } else if (value.trim().length > 64) {
      return NameValidationError.long;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == NameValidationError.empty) {
      return 'İsim kısmı boş bırakılamaz';
    } else if (error == NameValidationError.short) {
      return 'İsminiz en az 2 karakterden oluşmalıdır';
    } else if (error == NameValidationError.long) {
      return 'İsminiz en fazla 64 karakterden oluşmalıdır';
    }
    return null;
  }
}

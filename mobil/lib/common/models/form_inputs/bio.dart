import 'package:biberon/common/models/models.dart';

enum BioValidationError { long }

class Bio extends FormzInputWithErrorMessage<String, BioValidationError> {
  const Bio.pure() : super.pure('');
  const Bio.dirty([super.value = '']) : super.dirty();

  @override
  BioValidationError? validator(String value) {
    if (value.trim().length > 255) {
      return BioValidationError.long;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == BioValidationError.long) {
      return 'Bio kısmı en fazla 255 karakterden oluşmalıdır';
    }
    return null;
  }
}

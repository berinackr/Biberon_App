import 'package:formz/formz.dart';

enum NotesValidationError { invalid }

class Notes extends FormzInput<String?, NotesValidationError> {
  const Notes.pure() : super.pure(null);
  const Notes.dirty([super.value]) : super.dirty();

  @override
  NotesValidationError? validator(String? value) {
    if (value != null && value.length > 1500) {
      return NotesValidationError.invalid;
    }
    return null;
  }

  String? get errorMessage {
    if (error == NotesValidationError.invalid) {
      return 'Notlar 1500 karakterden fazla olamaz.';
    }
    return null;
  }
}

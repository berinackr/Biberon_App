import 'package:biberon/common/models/models.dart';

enum PostPlainTextValidationError { short, empty, long }

class PostPlainText
    extends FormzInputWithErrorMessage<String, PostPlainTextValidationError> {
  const PostPlainText.pure() : super.pure('');
  const PostPlainText.dirty([super.value = '']) : super.dirty();

  @override
  PostPlainTextValidationError? validator(String value) {
    if (value.trim().isEmpty) {
      return PostPlainTextValidationError.empty;
    } else if (value.trim().isEmpty) {
      return PostPlainTextValidationError.short;
    } else if (value.trim().length > 15000) {
      return PostPlainTextValidationError.long;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == PostPlainTextValidationError.empty) {
      return 'Soru içeriği boş olamaz';
    } else if (error == PostPlainTextValidationError.short) {
      return 'Soru içeriği en az 2 karakter olmalıdır';
    } else if (error == PostPlainTextValidationError.long) {
      return 'Post içeriği en fazla 10000 karakter olmalıdır';
    }
    return null;
  }
}

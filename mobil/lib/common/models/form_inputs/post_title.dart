import 'package:biberon/common/models/input_model.dart';

enum PostTitleValidationError { empty, short, long }

class PostTitle
    extends FormzInputWithErrorMessage<String, PostTitleValidationError> {
  const PostTitle.pure() : super.pure('');
  const PostTitle.dirty([super.value = '']) : super.dirty();

  @override
  PostTitleValidationError? validator(String value) {
    if (value.trim().isEmpty) {
      return PostTitleValidationError.empty;
    } else if (value.trim().isEmpty) {
      return PostTitleValidationError.short;
    } else if (value.trim().length > 150) {
      return PostTitleValidationError.long;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == PostTitleValidationError.empty) {
      return 'Başlık boş olamaz';
    } else if (error == PostTitleValidationError.short) {
      return 'Başlık en az 1 karakter olmalıdır';
    } else if (error == PostTitleValidationError.long) {
      return 'Başlık en fazla 150 karakter olmalıdır';
    }
    return null;
  }
}

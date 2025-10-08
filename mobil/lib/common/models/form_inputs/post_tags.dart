import 'package:biberon/common/models/models.dart';

enum PostTagsValidationError { lessthanzero, highthantwo }

class PostTags
    extends FormzInputWithErrorMessage<List<int>, PostTagsValidationError> {
  const PostTags.pure() : super.pure(const []);
  const PostTags.dirty([super.value = const []]) : super.dirty();

  @override
  PostTagsValidationError? validator(List<dynamic> value) {
    // ignore: prefer_is_empty
    if (value.length == 0) {
      return PostTagsValidationError.lessthanzero;
    } else if (value.length > 2) {
      return PostTagsValidationError.highthantwo;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (error == PostTagsValidationError.lessthanzero) {
      return 'En az 1 etiket seçmelisiniz';
    } else if (error == PostTagsValidationError.highthantwo) {
      return 'En fazla 2 etiket seçebilirsiniz';
    }
    return null;
  }
}

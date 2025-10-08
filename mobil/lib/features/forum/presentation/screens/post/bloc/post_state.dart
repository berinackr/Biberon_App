part of 'post_bloc.dart';

class PostState extends Equatable {
  const PostState({
    this.tags = const PostTags.pure(),
    this.status,
    this.errorMessage,
    this.id,
    this.plainText = const PostPlainText.pure(),
    this.title = const PostTitle.pure(),
    this.content,
  });

  final FormzSubmissionStatus? status;
  final String? errorMessage;
  final int? id;
  final PostPlainText plainText;
  final Delta? content;
  final PostTags tags;
  final PostTitle title;

  bool get isValid => plainText.isValid && title.isValid && tags.isValid;

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        id,
        plainText,
        tags,
        title,
        content,
      ];

  PostState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    int? id,
    PostPlainText? plainText,
    PostTags? tags, // Optional parameter for tags
    PostTitle? title,
    Delta? content,
  }) {
    return PostState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      id: id ?? this.id,
      plainText: plainText ?? this.plainText,
      tags: tags ?? this.tags,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}

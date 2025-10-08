part of 'post_bloc.dart';

class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class PlainTextChanged extends PostEvent {
  const PlainTextChanged({required this.plainText});

  final String plainText;

  @override
  List<Object> get props => [plainText];
}

class TitleChanged extends PostEvent {
  const TitleChanged({required this.title});

  final String title;

  @override
  List<Object> get props => [title];
}

class TagChanged extends PostEvent {
  const TagChanged(this.tagId);

  final int tagId;

  @override
  List<Object> get props => [tagId];
}

class PostContentRequested extends PostEvent {
  const PostContentRequested({required this.plainText, required this.content});
  final String plainText;
  final Delta content;

  @override
  List<Object> get props => [plainText, content];
}

class EditPostRequested extends PostEvent {
  const EditPostRequested({required this.plainText, this.id});
  final String? id;
  final String plainText;

  @override
  List<Object> get props => [plainText];
}

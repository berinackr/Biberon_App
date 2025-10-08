import 'package:biberon/common/models/models.dart';
import 'package:biberon/features/forum/data/repository/forum_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    required ForumRepository forumRepository,
    required Talker logger,
  })  : _forumRepository = forumRepository,
        _logger = logger,
        super(const PostState()) {
    on<PlainTextChanged>(_onPlainTextChanged);
    on<TitleChanged>(_onTitleChanged);
    on<TagChanged>(_onTagChanged);
    on<PostContentRequested>(_onPostContentRequested);
    on<EditPostRequested>(_onEditPostRequested);
  }

  final ForumRepository _forumRepository;
  final Talker _logger;

  Future<void> _onPlainTextChanged(
    PlainTextChanged event,
    Emitter<PostState> emit,
  ) async {
    emit(
      state.copyWith(
        plainText: PostPlainText.dirty(event.plainText),
      ),
    );
  }

  Future<void> _onTitleChanged(
    TitleChanged event,
    Emitter<PostState> emit,
  ) async {
    emit(
      state.copyWith(
        title: PostTitle.dirty(event.title),
      ),
    );
  }

  Future<void> _onTagChanged(
    TagChanged event,
    Emitter<PostState> emit,
  ) async {
    final tags = state.tags.value;
    var updatedTags = <int>[];
    if (tags.contains(event.tagId)) {
      updatedTags = List<int>.from(tags)..remove(event.tagId);
    } else {
      updatedTags = List<int>.from(tags)..add(event.tagId);
    }
    emit(
      state.copyWith(
        tags: PostTags.dirty(updatedTags),
      ),
    );
  }

  Future<void> _onPostContentRequested(
    PostContentRequested event,
    Emitter<PostState> emit,
  ) async {
    _logger.info('Post content requested');
    if (state.isValid) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
      final result = await _forumRepository.postContent(
        title: state.title.value,
        body: event.content,
        tags: state.tags.value,
      );
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
        },
        (_) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
      );
    } else {
      if (state.title.displayError == null && state.title.value.isEmpty) {
        emit(
          state.copyWith(
            title: const PostTitle.dirty(),
          ),
        );
      }
      if (state.plainText.displayError == null &&
          state.plainText.value.trim().isEmpty) {
        emit(
          state.copyWith(
            plainText: const PostPlainText.dirty(),
          ),
        );
      }
      if (state.tags.displayError == null && state.tags.value.isEmpty) {
        emit(
          state.copyWith(
            tags: const PostTags.dirty(),
          ),
        );
      }
    }

    _logger.info(state.status);
  }

  Future<void> _onEditPostRequested(
    EditPostRequested event,
    Emitter<PostState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );
    _logger.info('Edit post requested');

    final result = await _forumRepository.editPost(
      id: event.id!,
      title: state.title.value,
      body: state.content!,
      tags: state.tags.value,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.toString(),
          ),
        );
      },
      (_) => emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      ),
    );
  }
}

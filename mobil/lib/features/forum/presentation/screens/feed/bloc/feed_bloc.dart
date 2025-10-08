import 'package:biberon/features/forum/data/repository/forum_repository.dart';
import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc({
    required ForumRepository forumRepository,
    required Talker logger,
  })  : _forumRepository = forumRepository,
        _logger = logger,
        super(const FeedState()) {
    on<RefreshFeed>(_onRefreshFeed);
    on<LoadMoreFeed>(_onLoadMoreFeed);
    on<FieldChangedSortDesc>(_onFieldChangedSortDesc);
    on<FieldChangedTagId>(_onFieldChangedTagId);
    on<FieldChangedSortType>(_onFieldChangedSortType);
    on<RefreshBookmarkedPosts>(_onRefreshBookmarkedPosts);
    on<SetPostBookmarked>(_onSetPostBookmarked);
    on<RemovePostBookmarked>(_onRemovePostBookmarked);
    on<LoadMoreBookmarkedPosts>(_onLoadMoreBookmarkedPosts);
    on<SearchPosts>(_onSearchPosts);
    on<SearchTextChanged>(_onSearchTextChanged);
  }

  final ForumRepository _forumRepository;
  final Talker _logger;

  Future<void> _onRefreshFeed(
    RefreshFeed event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final feed = await _forumRepository.getForumFeed(
      orderWith: state.sortType,
      orderBy: state.sortDesc ? 'desc' : 'asc',
      tag: state.tagId == 0 ? null : state.tagId,
    );
    feed.fold(
      (error) {
        _logger.error('Error getting forum feed', error);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: () => error.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            // Bunu direkt olarak null atayamadığım için () => null şeklinde
            errorMessage: () => null,
            posts: response.data,
            searchedPosts: response.data,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreFeed(
    LoadMoreFeed event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final lastPost = state.posts.last;
    String? date;
    int? count;
    switch (state.sortType) {
      case 'createdAt':
        date = lastPost.createdAt!.toIso8601String();
      case 'voteCount':
        count = lastPost.totalVote;
      case 'commentCount':
        count = lastPost.totalAnswerCount;
      case 'lastActivity':
        date = lastPost.lastActivityDate!.toIso8601String();
    }
    final result = await _forumRepository.getForumFeed(
      orderWith: state.sortType,
      orderBy: state.sortDesc ? 'desc' : 'asc',
      tag: state.tagId == 0 ? null : state.tagId,
      keyId: lastPost.id,
      count: count,
      date: date,
    );
    result.fold(
      (error) {
        _logger.error('Error getting forum feed', error);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: () => error.message,
          ),
        );
      },
      (response) {
        if (response.data != null && response.data!.isNotEmpty) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
              posts: [...state.posts, ...response.data!],
              searchedPosts: [...state.searchedPosts, ...response.data!],
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: () =>
                  'Tüm postlar yüklendi. : ${state.posts.length}',
            ),
          );
        }
      },
    );
  }

  Future<void> _onFieldChangedSortDesc(
    FieldChangedSortDesc event,
    Emitter<FeedState> emit,
  ) async {
    emit(
      state.copyWith(
        sortDesc: event.sort,
      ),
    );
  }

  Future<void> _onFieldChangedTagId(
    FieldChangedTagId event,
    Emitter<FeedState> emit,
  ) async {
    emit(
      state.copyWith(
        tagId: event.tagId,
      ),
    );
  }

  Future<void> _onFieldChangedSortType(
    FieldChangedSortType event,
    Emitter<FeedState> emit,
  ) async {
    emit(
      state.copyWith(
        sortType: event.sortType,
      ),
    );
  }

  Future<void> _onRefreshBookmarkedPosts(
    RefreshBookmarkedPosts event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final bookmarks = await _forumRepository.getBookmarkedPosts();
    bookmarks.fold(
      (error) {
        _logger.error('Error getting bookmarked posts', error);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: () => error.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            bookmarkedPosts: response.data,
            isBookmarksCheckedBefore: true,
            errorMessage: () => null,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreBookmarkedPosts(
    LoadMoreBookmarkedPosts event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await _forumRepository.getBookmarkedPosts(
      createdAt: state.bookmarkedPosts.last.createdAt!.toIso8601String(),
      keyId: state.bookmarkedPosts.last.id,
    );
    result.fold(
      (error) {
        _logger.error('Error getting bookmarked posts', error);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: () => error.message,
          ),
        );
      },
      (response) {
        if (response.data != null && response.data!.isNotEmpty) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
              bookmarkedPosts: [...state.bookmarkedPosts, ...response.data!],
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: () =>
                  // ignore: lines_longer_than_80_chars
                  'Tüm kayıtlı postlar yüklendi. : ${state.bookmarkedPosts.length}',
            ),
          );
        }
      },
    );
  }

  Future<void> _onSetPostBookmarked(
    SetPostBookmarked event,
    Emitter<FeedState> emit,
  ) async {
    late Post bookmarkedPost;
    final originalPostsList = state.posts
        .map(
          (e) => e,
        )
        .toList();
    final originalBookmarkedPostsList = state.bookmarkedPosts
        .map(
          (e) => e,
        )
        .toList();
    final editedPostsList = originalPostsList.map((element) {
      if (element.id == event.id) {
        return bookmarkedPost = element.copyWith(bookmarked: true);
      } else {
        return element;
      }
    }).toList();
    final editedBookmarkedPostsList =
        originalBookmarkedPostsList.map((e) => e).toList()
          ..add(bookmarkedPost)
          //sort with createdDate parameter
          ..sort(
            (a, b) => a.createdAt!.compareTo(b.createdAt!),
          );
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        posts: editedPostsList,
        bookmarkedPosts: editedBookmarkedPostsList,
      ),
    );
    final result = await _forumRepository.setPostBookmarked(event.id);
    result.fold(
      (error) {
        _logger.error('Error setting post bookmarked', error);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            posts: originalPostsList,
            bookmarkedPosts: originalBookmarkedPostsList,
            errorMessage: () => error.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            errorMessage: () => null,
          ),
        );
      },
    );
  }

  Future<void> _onRemovePostBookmarked(
    RemovePostBookmarked event,
    Emitter<FeedState> emit,
  ) async {
    final originalPostList = state.posts.map((e) => e).toList();
    final originalBookmarkedList = state.bookmarkedPosts.map((e) => e).toList();
    final deletedPostList = originalPostList.map((element) {
      if (element.id == event.id) {
        return element.copyWith(bookmarked: false);
      } else {
        return element;
      }
    }).toList();
    final deletedBookmarkedList = originalBookmarkedList
        .map((element) => element)
        .toList()
      ..removeWhere((element) => element.id == event.id);
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        posts: deletedPostList,
        bookmarkedPosts: deletedBookmarkedList,
      ),
    );
    final result = await _forumRepository.removePostBookmarked(event.id);
    result.fold(
      (error) {
        _logger.error('Error removing post bookmarked', error);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            posts: originalPostList,
            bookmarkedPosts: originalBookmarkedList,
            errorMessage: () => error.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            errorMessage: () => null,
          ),
        );
      },
    );
  }

  Future<void> _onSearchPosts(
    SearchPosts event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final searchList = state.searchedPosts.map((e) => e).toList();
    final result = searchList;
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.success,
        posts: result,
      ),
    );
  }

  Future<void> _onSearchTextChanged(
    SearchTextChanged event,
    Emitter<FeedState> emit,
  ) async {
    emit(
      state.copyWith(
        searchText: event.query,
      ),
    );
  }
}

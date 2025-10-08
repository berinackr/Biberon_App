part of 'feed_bloc.dart';

class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class RefreshFeed extends FeedEvent {
  const RefreshFeed();

  @override
  List<Object> get props => [];
}

class RefreshBookmarkedPosts extends FeedEvent {
  const RefreshBookmarkedPosts();

  @override
  List<Object> get props => [];
}

class LoadMoreFeed extends FeedEvent {
  const LoadMoreFeed();

  @override
  List<Object> get props => [];
}

class SetPostBookmarked extends FeedEvent {
  const SetPostBookmarked({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class RemovePostBookmarked extends FeedEvent {
  const RemovePostBookmarked({required this.id, required this.tabIndex});

  final String id;
  final int tabIndex;

  @override
  List<Object> get props => [id, tabIndex];
}

class FieldChangedSortDesc extends FeedEvent {
  const FieldChangedSortDesc({required this.sort});

  final bool sort;

  @override
  List<Object> get props => [sort];
}

class FieldChangedTagId extends FeedEvent {
  const FieldChangedTagId({required this.tagId});

  final int tagId;

  @override
  List<Object> get props => [tagId];
}

class FieldChangedSortType extends FeedEvent {
  const FieldChangedSortType({required this.sortType});

  final String sortType;

  @override
  List<Object> get props => [sortType];
}

class LoadMoreBookmarkedPosts extends FeedEvent {
  const LoadMoreBookmarkedPosts();

  @override
  List<Object> get props => [];
}

class SearchPosts extends FeedEvent {
  const SearchPosts();

  @override
  List<Object> get props => [];
}

class SearchTextChanged extends FeedEvent {
  const SearchTextChanged({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}

import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    required this.initialPosts,
    required this.index,
    required this.tabController,
    super.key,
  });

  final List<Post> initialPosts;
  final int index;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (initialPosts[index].bookmarked ?? true) {
          context.read<FeedBloc>().add(
                RemovePostBookmarked(
                  id: initialPosts[index].id!,
                  tabIndex: tabController.index,
                ),
              );
        } else {
          context.read<FeedBloc>().add(
                SetPostBookmarked(
                  id: initialPosts[index].id!,
                ),
              );
        }
      },
      icon: initialPosts[index].bookmarked == null
          ? const Icon(Icons.bookmark_outline)
          : initialPosts[index].bookmarked!
              ? const Icon(Icons.bookmark)
              : const Icon(
                  Icons.bookmark_outline_outlined,
                ),
    );
  }
}

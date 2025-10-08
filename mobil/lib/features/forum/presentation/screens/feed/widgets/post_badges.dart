import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/forum_badge.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PostBadges extends StatelessWidget {
  const PostBadges({
    required this.index,
    required this.state,
    required this.tabController,
    super.key,
  });

  final int index;
  final FeedState state;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final initialPosts =
        tabController.index == 1 ? state.bookmarkedPosts : state.posts;
    if (initialPosts.isEmpty || index >= initialPosts.length) {
      return const SizedBox(); // Or you can provide an alternative widget here
    }
    return Row(
      children: [
        // Reaction Badge
        ForumBadge(
          icon: Icons.poll_outlined,
          text: initialPosts[index].totalVote.toString(),
        ),

// Postcount Badge
        ForumBadge(
          icon: Icons.question_answer_outlined,
          text: initialPosts[index].totalAnswerCount.toString(),
        ),
      ],
    );
  }
}

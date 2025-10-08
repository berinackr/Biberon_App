import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popover/popover.dart';

class MoreButton extends StatelessWidget {
  const MoreButton({
    required this.initialPosts,
    required this.index,
    super.key,
  });
  final List<Post> initialPosts;
  final int index;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.user;
    return GestureDetector(
      onTap: () {
        final selectedPost = initialPosts[index];
        if (user.id == initialPosts[index].user!.id!) {
          showPopover(
            context: context,
            bodyBuilder: (context) => MenuItems(
              selectedPost: selectedPost,
            ),
          );
        }
      },
      child: user!.id == initialPosts[index].user!.id!
          ? const Icon(Icons.more_vert)
          : Container(),
    );
  }
}

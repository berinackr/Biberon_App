import 'package:biberon/common/app/router/app_routes.dart';
import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuItems extends StatelessWidget {
  const MenuItems({required this.selectedPost, super.key});
  final Post selectedPost;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              context.pushNamed(AppRoutes.editPost, extra: selectedPost);
            },
            child: const Text('Düzenle'),
          ),
          TextButton(onPressed: () {}, child: const Text('Sil')),
        ],
      ),
    );
  }
}

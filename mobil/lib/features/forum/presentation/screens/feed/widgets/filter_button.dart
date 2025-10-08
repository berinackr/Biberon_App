import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    required this.viewportConstraints,
    super.key,
  });
  final BoxConstraints viewportConstraints;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 50,
        minWidth: viewportConstraints.maxWidth,
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<FeedBloc>().add(const RefreshFeed());
          context.pop();
        },
        child: const Text('Filtrele'),
      ),
    );
  }
}

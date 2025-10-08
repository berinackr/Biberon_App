import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForumSearchWidget extends StatelessWidget {
  const ForumSearchWidget({
    required this.viewportConstraints,
    required this.tabController,
    required this.state,
    super.key,
  });

  final BoxConstraints viewportConstraints;
  final TabController tabController;
  final FeedState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Container(
        color: Colors.transparent,
        constraints: BoxConstraints(
          minHeight: 50,
          minWidth: viewportConstraints.maxWidth,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: SearchBar(
                onChanged: (value) => context
                    .read<FeedBloc>()
                    .add(SearchTextChanged(query: value)),
                hintText: 'İndirilen konularda ara...',
                trailing: [
                  IconButton(
                    onPressed: () {
                      context.read<FeedBloc>().add(const SearchPosts());
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
                leading: IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<FeedBloc>(),
                        child: BlocBuilder<FeedBloc, FeedState>(
                          builder: (context, state) {
                            return FilterBottomSheet(
                              tabController: tabController,
                              state: state,
                            );
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

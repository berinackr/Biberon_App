import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class BookmarkedPostsFeed extends StatelessWidget {
  const BookmarkedPostsFeed({
    required this.state,
    required this.isLoading,
    required ScrollController scrollControllerForBookmarkedPosts,
    required TabController tabController,
    super.key,
  })  : _scrollControllerForBookmarkedPosts =
            scrollControllerForBookmarkedPosts,
        _tabController = tabController;

  final FeedState state;
  final bool isLoading;
  final ScrollController _scrollControllerForBookmarkedPosts;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure &&
            state.errorMessage != null) {
          Toast.showToast(
            context,
            state.errorMessage!,
            ToastType.error,
          );
        }
      },
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (state.bookmarkedPosts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Henüz kaydedilmiş postunuz yok. 🥲',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        '''Bir postu kaydetmek için postun üzerindeki bookmark ikonuna tıklayın.''',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                      const Icon(Icons.bookmark),
                    ],
                  ),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<FeedBloc>()
                          .add(const RefreshBookmarkedPosts());
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: constraints.maxHeight,
                          child: isLoading && state.bookmarkedPosts.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Opacity(
                                  opacity: isLoading ? 0.5 : 1,
                                  child: ListView.builder(
                                    key: const PageStorageKey(
                                      'bookmarked_posts_page_view_key',
                                    ),
                                    controller:
                                        _scrollControllerForBookmarkedPosts,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: state.bookmarkedPosts.length,
                                    itemBuilder: (context, index) => PostCard(
                                      initialPosts: state.bookmarkedPosts,
                                      tabController: _tabController,
                                      viewportConstraints: constraints,
                                      index: index,
                                      state: state,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

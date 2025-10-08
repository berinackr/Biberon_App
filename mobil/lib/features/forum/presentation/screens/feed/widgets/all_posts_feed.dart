import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/forum_search_widget.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AllPostsFeed extends StatelessWidget {
  const AllPostsFeed({
    required TabController tabController,
    required this.state,
    required this.isLoading,
    required ScrollController scrollControllerForAllPosts,
    super.key,
  })  : _tabController = tabController,
        _scrollControllerForAllPosts = scrollControllerForAllPosts;

  final TabController _tabController;
  final FeedState state;
  final bool isLoading;
  final ScrollController _scrollControllerForAllPosts;

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
            builder: (context, viewportConstraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                  minWidth: viewportConstraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<FeedBloc>().add(const RefreshFeed());
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: !_scrollControllerForAllPosts.hasClients ||
                                  _scrollControllerForAllPosts.position.pixels <
                                      1
                              ? 100
                              : 0,
                          child: ForumSearchWidget(
                            viewportConstraints: viewportConstraints,
                            tabController: _tabController,
                            state: state,
                          ),
                        ),
                        Expanded(
                          child: isLoading && state.posts.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Opacity(
                                  opacity: isLoading ? 0.5 : 1,
                                  child: ListView.builder(
                                    key: const PageStorageKey(
                                      'all_posts_page_view_key',
                                    ),
                                    controller: _scrollControllerForAllPosts,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: state.posts.length,
                                    itemBuilder: (context, index) => PostCard(
                                      initialPosts: state.posts,
                                      tabController: _tabController,
                                      viewportConstraints: viewportConstraints,
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

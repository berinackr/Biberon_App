import 'package:biberon/features/forum/forum.dart';
import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:biberon/features/forum/presentation/screens/feed/feed.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  final _scrollControllerForAllPosts = ScrollController();
  final _scrollControllerForBookmarkedPosts = ScrollController();

  late final TabController _tabController;

  bool showGoToTopButton = false;

  void _scrollListenerFeed(
    ScrollController scrollController,
    void Function() loadMoreCallback,
    TabController tabController,
    int tabIndex,
  ) {
    if (scrollController.hasClients && scrollController.positions.isNotEmpty) {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          tabController.index == tabIndex) {
        loadMoreCallback.call();
      }
      if (_scrollControllerForAllPosts.position.pixels > 1000 &&
          _tabController.index == 0) {
        setState(() {
          showGoToTopButton = true;
        });
      } else if (_scrollControllerForAllPosts.position.pixels < 1000 &&
          _tabController.index == 0) {
        setState(() {
          showGoToTopButton = false;
        });
      }
    }
  }

  void _scrollListenerAllPosts() {
    _scrollListenerFeed(
      _scrollControllerForAllPosts,
      () => context.read<FeedBloc>().add(const LoadMoreFeed()),
      _tabController,
      0,
    );
  }

  void _scrollListenerBookmarkedPosts() {
    _scrollListenerFeed(
      _scrollControllerForBookmarkedPosts,
      () => context.read<FeedBloc>().add(const LoadMoreBookmarkedPosts()),
      _tabController,
      1,
    );
  }

  void _tabControllerListener() {
    if (_tabController.index == 1 &&
        !context.read<FeedBloc>().state.isBookmarksCheckedBefore) {
      context.read<FeedBloc>().add(
            const RefreshBookmarkedPosts(),
          );
    }
    if (_tabController.indexIsChanging) {
      setState(() {
        showGoToTopButton = false;
      });
    }
  }

  @override
  void initState() {
    _scrollControllerForAllPosts.addListener(_scrollListenerAllPosts);
    _scrollControllerForBookmarkedPosts
        .addListener(_scrollListenerBookmarkedPosts);
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _tabController.addListener(_tabControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerForAllPosts
      ..removeListener(_scrollListenerAllPosts)
      ..dispose();
    _scrollControllerForBookmarkedPosts
      ..removeListener(_scrollListenerBookmarkedPosts)
      ..dispose();
    _tabController
      ..removeListener(_tabControllerListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FeedBloc>().state;
    final isLoading = state.status == FormzSubmissionStatus.inProgress;

    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: showGoToTopButton
          ? FloatingActionButton.small(
              onPressed: () {
                final tabIndex = _tabController.index;
                (tabIndex == 0
                        ? _scrollControllerForAllPosts
                        : _scrollControllerForBookmarkedPosts)
                    .animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Tüm Konular',
            ),
            Tab(
              text: 'Takip Edilen Konular',
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          AllPostsFeed(
            tabController: _tabController,
            state: state,
            isLoading: isLoading,
            scrollControllerForAllPosts: _scrollControllerForAllPosts,
          ),
          BookmarkedPostsFeed(
            state: state,
            isLoading: isLoading,
            scrollControllerForBookmarkedPosts:
                _scrollControllerForBookmarkedPosts,
            tabController: _tabController,
          ),
        ],
      ),
    );
  }
}

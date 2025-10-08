import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/bookmark_button.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/more_button.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/post_badges.dart';

import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    required this.state,
    required this.index,
    required this.viewportConstraints,
    required this.tabController,
    required this.initialPosts,
    super.key,
  });

  final FeedState state;
  final int index;
  final BoxConstraints viewportConstraints;
  final TabController tabController;
  final List<Post> initialPosts;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  List<Post> get initialPosts => widget.initialPosts;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100,
              minWidth: widget.viewportConstraints.maxWidth,
            ),
            child: Card(
              child: InkWell(
                onTap: () {
                  Toast.showToast(
                    context,
                    '''id: ${initialPosts[widget.index].id}\ncreatedAt: ${initialPosts[widget.index].createdAt}\ntotalAnswerCount: ${initialPosts[widget.index].totalAnswerCount}''',
                    ToastType.success,
                  );
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Row(
                        children: [
                          MoreButton(
                            initialPosts: initialPosts,
                            index: widget.index,
                          ),
                          BookmarkButton(
                            initialPosts: initialPosts,
                            index: widget.index,
                            tabController: widget.tabController,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 125,
                      ),
                      width: 15,
                      // İki tag var ancak ilk tagin rengini alıyor
                      // belki daha sonra gradient eklenebilir ya da komple tek
                      // renk olabilir
                      // color: Theme.of(context).colorScheme.secondary,
                      color: initialPosts[widget.index].tags!.isNotEmpty
                          ? EnumTags.fromName(
                              initialPosts[widget.index]
                                  .tags!
                                  .first
                                  .name
                                  .toString(),
                            )?.color
                          : Colors.green,
                    ),
                    SizedBox(
                      height: 120,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      initialPosts[widget.index].title ?? '',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (initialPosts[widget.index].tags !=
                                          null)
                                        for (final tag
                                            in initialPosts[widget.index].tags!)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 2,
                                              ),
                                              child: Text(
                                                tag.name!,
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      PostBadges(
                                        index: widget.index,
                                        tabController: widget.tabController,
                                        state: widget.state,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

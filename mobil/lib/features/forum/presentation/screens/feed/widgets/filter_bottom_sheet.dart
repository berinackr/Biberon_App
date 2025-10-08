import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/filter_button.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/sort_field.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/sort_type_field.dart';
import 'package:biberon/features/forum/presentation/screens/feed/widgets/tag_field.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
    required TabController tabController,
    required this.state,
    super.key,
  }) : _tabController = tabController;

  final TabController _tabController;
  final FeedState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: viewportConstraints.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _tabController.index == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SortTypeField(state: state),
                        SortField(state: state),
                        TagField(state: state),
                        FilterButton(
                          viewportConstraints: viewportConstraints,
                        ),
                      ],
                    )
                  : const Center(
                      child: Text('Takip Edilenler'),
                    ),
            ),
          ),
        );
      },
    );
  }
}

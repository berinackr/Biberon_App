import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.index = 0,
    this.homeViewKey,
  });

  final int index;
  final Key? homeViewKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        return HomeTab(
          viewportConstraints: viewportConstraints,
        );
      },
    );
  }
}

// HomeTab
class HomeTab extends StatelessWidget {
  const HomeTab({
    required this.viewportConstraints,
    super.key,
  });

  final BoxConstraints viewportConstraints;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const Refresh());
        Toast.showToast(context, 'home refresh', ToastType.success);
      },
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
            minWidth: viewportConstraints.maxWidth,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeScreenPregnancyStatusPercentage(
                  viewportConstraints: viewportConstraints,
                ),
                const SizedBox(height: 20),
                HomescreenUpcomingAppointmentReminder(
                  viewportConstraints: viewportConstraints,
                ),
                const SizedBox(height: 20),
                WeeklyDoctorSuggestion(
                  viewportConstraints: viewportConstraints,
                  imageSize: 35,
                ),
                const SizedBox(height: 20),
                const ForumCategories(),
                const SizedBox(height: 20),
                OurMeditations(
                  viewportConstraints: viewportConstraints,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

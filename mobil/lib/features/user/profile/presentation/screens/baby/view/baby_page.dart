import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/birth_date.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/birth_height.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/birth_time.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/birth_weight.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/delete_button.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/gender_input.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/name_input.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/update_button.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class BabyPage extends StatefulWidget {
  const BabyPage({super.key});

  @override
  State<BabyPage> createState() => _BabyPageState();
}

class _BabyPageState extends State<BabyPage> {
  bool canPop = true;
  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (BabyBloc bloc) => bloc.state.status == FormzSubmissionStatus.inProgress,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Bebeğim'),
      ),
      body: BlocListener<BabyBloc, BabyState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.failure) {
            Toast.showToast(
              context,
              state.errorMessage!,
              ToastType.error,
            );
          } else if (state.status == FormzSubmissionStatus.success &&
              state.isUpdated) {
            Toast.showToast(
              context,
              '''Bebek bilgisi başarıyla güncellendi.''',
              ToastType.success,
            );
            context.read<BabyBloc>().add(const ClearNotificationStates());
          } else if (state.status == FormzSubmissionStatus.success &&
              state.isAdded) {
            Toast.showToast(
              context,
              '''Bebek bilgisi başarıyla eklendi.''',
              ToastType.success,
            );
            context.read<BabyBloc>().add(const ClearNotificationStates());
          }
        },
        child: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: isLoading ? 1.0 : 0,
                child: const CircularProgressIndicator(),
              ),
            ),
            LayoutBuilder(
              builder: (context, viewportConstraints) {
                final state = context.watch<BabyBloc>().state;
                return RefreshIndicator(
                  notificationPredicate:
                      state.babyId != null ? (_) => true : (_) => false,
                  onRefresh: () async {
                    context.read<BabyBloc>().add(
                          BabyEventLoad(state.babyId),
                        );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                        minWidth: viewportConstraints.maxWidth,
                      ),
                      child: IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Column(
                                  children: [
                                    NameTextInput(state: state),
                                    const SizedBox(height: 15),
                                    DateOfBirthWidget(
                                      state: state,
                                    ),
                                    const SizedBox(height: 10),
                                    TimeOfBirthWidget(
                                      state: state,
                                    ),
                                    const SizedBox(height: 10),
                                    BabyGender(
                                      state: state,
                                    ),
                                    const SizedBox(height: 10),
                                    BirthHeightInput(state: state),
                                    const SizedBox(height: 10),
                                    BirthWeightInput(state: state),
                                    const SizedBox(height: 20),
                                    BabyNotes(state: state),
                                    const Expanded(
                                      child: SizedBox(
                                        height: 10,
                                      ),
                                    ),
                                    if (state.babyId != null)
                                      DeleteButton(state: state),
                                    const SizedBox(height: 10),
                                    UpdateButton(state: state),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

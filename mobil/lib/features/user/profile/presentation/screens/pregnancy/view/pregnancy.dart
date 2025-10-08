import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class PregnancyPage extends StatefulWidget {
  const PregnancyPage({super.key});

  @override
  State<PregnancyPage> createState() => _PregnancyPageState();
}

class _PregnancyPageState extends State<PregnancyPage> {
  bool canPop = true;
  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (PregnancyBloc bloc) =>
          bloc.state.status == FormzSubmissionStatus.inProgress,
    );
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   Icons(Icons.deblur_rounded)
        // ], // `TODO`(umutakpinar): burada kaldın
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Hamileliğim'),
      ),
      body: BlocListener<PregnancyBloc, PregnancyState>(
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
              '''Hamilelik bilgisi başarıyla güncellendi.''',
              ToastType.success,
            );
            context.read<PregnancyBloc>().add(const ClearNotificationStates());
          } else if (state.status == FormzSubmissionStatus.success &&
              state.isAdded) {
            Toast.showToast(
              context,
              '''Hamilelik bilgisi başarıyla eklendi.''',
              ToastType.success,
            );
            context.read<PregnancyBloc>().add(const ClearNotificationStates());
          } else if (state.status == FormzSubmissionStatus.success &&
              state.isCompleted) {
            Toast.showToast(
              context,
              '''Aktif hamilelik sonlandırıldı.''',
              ToastType.success,
            );
            context.read<PregnancyBloc>().add(const ClearNotificationStates());
          }
        },
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, viewportConstraints) {
                final state = context.watch<PregnancyBloc>().state;
                return RefreshIndicator(
                  notificationPredicate:
                      state.pregnancyId != null ? (_) => true : (_) => false,
                  onRefresh: () async {
                    context.read<PregnancyBloc>().add(
                          FetchPregnancy(state.pregnancyId),
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
                                    PregnancyType(state: state),
                                    if (state.fetuses != null)
                                      for (int i = 0;
                                          i < state.fetuses!.length;
                                          i++)
                                        FetusGender(i: i, state: state),
                                    DeliveryType(state: state),
                                    const SizedBox(height: 10),
                                    PregnancyNotes(state: state),
                                    const SizedBox(height: 20),
                                    if (state.isActive == null ||
                                        state.isActive!)
                                      DateSwitcher(state: state),
                                    const SizedBox(height: 20),
                                    DateWidgets(state: state),
                                    const Expanded(
                                      child: SizedBox(
                                        height: 10,
                                      ),
                                    ),
                                    if (state.isActive ?? false)
                                      CompleteButton(state: state),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (state.pregnancyId != null)
                                      DeleteButton(state: state),
                                    const SizedBox(height: 10),
                                    if (!(state.isActive != null &&
                                        !state.isActive! &&
                                        state.pregnancyId != null))
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

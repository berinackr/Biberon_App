import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/common/widgets/spaced_container.dart';
import 'package:biberon/features/authentication/presentation/screens/verify/verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final windowHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    final statusBarHeight = mediaQuery.padding.top;
    final availableHeight = windowHeight - bottomPadding - statusBarHeight;
    final isLoading = context.select(
              (VerifyBloc bloc) => bloc.state.sendEmailStatus,
            ) ==
            FormzSubmissionStatus.inProgress ||
        context.select(
              (VerifyBloc bloc) => bloc.state.status,
            ) ==
            FormzSubmissionStatus.inProgress ||
        context.select(
              (VerifyBloc bloc) => bloc.state.logoutStatus,
            ) ==
            FormzSubmissionStatus.inProgress;
    return BlocListener<VerifyBloc, VerifyState>(
      listenWhen: (previous, current) {
        return previous.status != current.status ||
            previous.sendEmailStatus != current.sendEmailStatus;
      },
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure ||
            state.sendEmailStatus == FormzSubmissionStatus.failure) {
          Toast.showToast(
            context,
            state.errorMessage ?? 'Bir sorun oluştu. Lütfen tekrar deneyin.',
            ToastType.error,
          );
        } else if (state.sendEmailStatus == FormzSubmissionStatus.success) {
          Toast.showToast(
            context,
            state.statusMessage ?? 'Doğrulama e-postası gönderildi.',
            ToastType.success,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: availableHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: isLoading ? 0.5 : 1.0,
                          child: AbsorbPointer(
                            absorbing: isLoading,
                            child: const SingleChildScrollView(
                              child: SpacedContainer(
                                child: Column(
                                  children: [
                                    VerifyHeaderText(),
                                    SizedBox(height: 24),
                                    CodeInput(),
                                    SizedBox(height: 24),
                                    VerifyButton(),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SendVerifyButton(),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        LogoutButton(),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Opacity(
                            opacity: isLoading ? 0.5 : 1.0,
                            child: Image.asset(
                              'assets/verify-mail/verify-bg.png',
                            ),
                          ),
                        ),
                        Center(
                          child: Opacity(
                            opacity: isLoading ? 1.0 : 0,
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

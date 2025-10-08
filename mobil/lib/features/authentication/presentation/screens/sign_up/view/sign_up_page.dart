import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/common/widgets/widgets.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final windowHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    final statusBarHeight = mediaQuery.padding.top;
    final isLoading = context.watch<SignUpBloc>().state.status ==
        FormzSubmissionStatus.inProgress;

    // Calculate available height more precisely
    final availableHeight = windowHeight - bottomPadding - statusBarHeight;
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          Toast.showToast(
            context,
            state.errorMessage ?? 'Bir sorun oluştu. Lütfen tekrar deneyin.',
            ToastType.error,
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
                          opacity: isLoading ? 0.5 : 1,
                          child: AbsorbPointer(
                            absorbing: isLoading,
                            child: SpacedContainer(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SignUpHeader(),
                                  const SizedBox(height: 24),
                                  const SignUpEmailTextField(),
                                  const SizedBox(height: 14),
                                  const SignUpNameTextField(),
                                  const SizedBox(height: 14),
                                  const SignUpPasswordTextField(),
                                  const SizedBox(height: 24),
                                  const SignUpUserAgreement(),
                                  const SizedBox(height: 14),
                                  const SignUpButton(),
                                  const SizedBox(height: 14),
                                  const SignUpRedirection(),
                                  const SizedBox(height: 24),
                                  OrDivider(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                  ),
                                  const SizedBox(height: 14),
                                  OauthSignings(
                                    onPressedGoogle: () => context
                                        .read<SignUpBloc>()
                                        .add(const SignUpGooglePressed()),
                                    onPressedApple: () => {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Opacity(
                            opacity: isLoading ? 0.5 : 1,
                            child: Image.asset(
                              'assets/sign-up/signup-bg.png',
                            ),
                          ),
                        ),
                        Center(
                          child: Opacity(
                            opacity: isLoading ? 1 : 0,
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

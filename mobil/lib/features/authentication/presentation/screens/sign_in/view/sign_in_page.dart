import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/common/widgets/spaced_container.dart';
import 'package:biberon/features/authentication/presentation/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
          (SignInBloc bloc) => bloc.state.status,
        ) ==
        FormzSubmissionStatus.inProgress;
    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 140,
                child: Image.asset(
                  'assets/sign-in/blue_star.png',
                ),
              ),
              Center(
                child: Opacity(
                  opacity: isLoading ? 1.0 : 0,
                  child: const CircularProgressIndicator(),
                ),
              ),
              Opacity(
                opacity: isLoading ? 0.5 : 1,
                child: AbsorbPointer(
                  absorbing: isLoading,
                  child: SpacedContainer(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width,
                            'assets/sign-in/decorative_colors.png',
                          ),
                          const SignInHeader(),
                          const SizedBox(height: 20),
                          const SignInForm(),
                          const SizedBox(height: 15),
                          const SignInText(text: 'veya'),
                          const SizedBox(height: 15),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SignInWithGoogleButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

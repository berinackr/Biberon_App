import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/common/widgets/spaced_container.dart';
import 'package:biberon/features/authentication/presentation/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:biberon/features/authentication/presentation/screens/forgot_password/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
          (ForgetPasswordBloc bloc) => bloc.state.status,
        ) ==
        FormzSubmissionStatus.inProgress;
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          Toast.showToast(
            context,
            state.errorMessage ?? 'Bir sorun oluştu. Lütfen tekrar deneyin.',
            ToastType.error,
          );
        } else if (state.status == FormzSubmissionStatus.success) {
          Toast.showToast(
            context,
            state.statusMessage ?? 'Başarılı',
            ToastType.success,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 150,
                child: Image.asset(
                  'assets/forgot_pass/pink_star.png',
                ),
              ),
              Positioned(
                right: 100,
                top: 10,
                child: Image.asset('assets/forgot_pass/blue_splash.png'),
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
                  child: const SpacedContainer(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ForgetPasswordImage(),
                          SizedBox(height: 15),
                          ForgetPasswordHeader(),
                          SizedBox(height: 10),
                          ForgetPasswordText(),
                          SizedBox(height: 40),
                          ForgetPasswordTextField(),
                          SizedBox(height: 40),
                          ForgetPasswordButton(),
                          SizedBox(height: 16),
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

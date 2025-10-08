import 'package:biberon/common/widgets/spaced_container.dart';
import 'package:biberon/features/authentication/presentation/screens/verify/verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

typedef VerifyWidgetBuilder = Widget Function();

class VerifyLayoutBuilder extends StatelessWidget {
  const VerifyLayoutBuilder({
    required this.header,
    required this.verifyHeaderText,
    required this.codeInput,
    required this.verifyButton,
    required this.sendVerifyButton,
    required this.logoutButton,
    super.key,
  });

  final VerifyWidgetBuilder header;
  final VerifyWidgetBuilder verifyHeaderText;
  final VerifyWidgetBuilder codeInput;
  final VerifyWidgetBuilder verifyButton;
  final VerifyWidgetBuilder sendVerifyButton;
  final VerifyWidgetBuilder logoutButton;

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            header(),
            Center(
              child: Opacity(
                opacity: isLoading ? 1.0 : 0,
                child: const CircularProgressIndicator(),
              ),
            ),
            Opacity(
              opacity: isLoading ? 0.5 : 1.0,
              child: AbsorbPointer(
                absorbing: isLoading,
                child: SingleChildScrollView(
                  child: SpacedContainer(
                    child: Column(
                      children: [
                        verifyHeaderText(),
                        codeInput(),
                        const SizedBox(height: 40),
                        verifyButton(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            sendVerifyButton(),
                            const SizedBox(
                              width: 5,
                            ),
                            logoutButton(),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

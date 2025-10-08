import 'package:biberon/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SignUpUserAgreement extends StatelessWidget {
  const SignUpUserAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    final userAgreement = context.select(
      (SignUpBloc bloc) => bloc.state.userAgreement,
    );
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              side: BorderSide(
                width: 1.5,
                color: userAgreement.displayError != null
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).primaryColor,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: userAgreement.value,
              visualDensity: VisualDensity.compact,
              isError: userAgreement.displayError != null && true,
              onChanged: (value) => context.read<SignUpBloc>().add(
                    SignUpUserAgreementChanged(userAgreement: value!),
                  ),
            ),
            InkWell(
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Kullanıcı Sözleşmesi ve Gizlilik Politikası',
                      ),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: FutureBuilder(
                          future: DefaultAssetBundle.of(context)
                              .loadString('assets/sign-up/user_policy.md'),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<String> snapshot,
                          ) {
                            if (snapshot.hasData) {
                              return Markdown(data: snapshot.data!);
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Kapat'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Sözleşmeyi ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: userAgreement.displayError != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).primaryColor,
                      decorationColor: userAgreement.displayError != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).primaryColor,
                    ),
              ),
            ),
            Text(
              'Okudum Anladım.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: userAgreement.displayError != null
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

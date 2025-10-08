import 'package:biberon/common/app/app.dart';
import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/user/profile/domain/models/pregnancy_model.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancies/bloc/pregnancies_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancies/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class PregnanciesPage extends StatefulWidget {
  const PregnanciesPage({super.key});

  @override
  State<PregnanciesPage> createState() => _PregnanciesPageState();
}

class _PregnanciesPageState extends State<PregnanciesPage> {
  @override
  Widget build(BuildContext context) {
    var isLoading = context.select(
      (PregnanciesBloc bloc) =>
          bloc.state.status == FormzSubmissionStatus.inProgress,
    );
    return BlocListener<PregnanciesBloc, PregnanciesState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          Toast.showToast(
            context,
            'Hamilelikler yüklenirken bir hata oluştu.',
            ToastType.error,
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
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
                  final List<Pregnancy?> result =
                      context.read<PregnanciesBloc>().state.pregnancies;
                  if (result.isEmpty) {
                    return InfoTextAddNewPregnancy(isLoading: isLoading);
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PregnanciesBloc>().add(
                              const FetchPregnancies(),
                            );
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: result.length,
                        itemBuilder: (context, index) => ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 100,
                            maxHeight: 100,
                          ),
                          child: Dismissible(
                            key: Key(result[index]!.id.toString()),
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Hamileliği Sil ❗️',
                                    ),
                                    content: const Text(
                                      '''Bu hamileliği silmek istediğinize emin misiniz?\nBu işlem geri alınamaz!''',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          context.pop(false);
                                        },
                                        child: const Text(
                                          'Hayır',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.pop(true);
                                        },
                                        child: const Text('Evet'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) async {
                              context.read<PregnanciesBloc>().add(
                                    DeletePregnancy(
                                      result[index]!.id,
                                    ),
                                  );
                              context
                                  .read<PregnanciesBloc>()
                                  .add(const FetchPregnancies());
                              // UI gets updated after 500ms bcs of the delay
                              await Future.delayed(
                                  const Duration(milliseconds: 500), () {
                                setState(() {});
                              });
                            },
                            background: const ColoredBox(
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                  Center(
                                    child: Text(
                                      'Hamileliği Sil',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            child: PregnancyCard(result: result, index: index),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () async {
            final isAnyActive =
                context.read<PregnanciesBloc>().state.pregnancies.any(
                      (element) => element.isActive,
                    );
            if (isAnyActive || isLoading) {
              Toast.showToast(
                context,
                '''Aktif hamilelik varken yeni hamilelik eklenemez. Lütfen aktif hamileliği sonlandırınız ya da siliniz.''',
                ToastType.error,
              );
            } else {
              await context
                  .pushNamed(
                AppRoutes.pregnancy,
              )
                  .then(
                (value) async {
                  if (value == true) {
                    isLoading = true; //just effect the UI
                    Future.delayed(const Duration(milliseconds: 500), () {
                      context.read<PregnanciesBloc>().add(
                            const FetchPregnancies(),
                          );
                      isLoading = false; //just effect the UI
                    });
                  }
                },
              );
            }
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}

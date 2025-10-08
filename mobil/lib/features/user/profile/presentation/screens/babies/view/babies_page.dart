import 'package:biberon/common/app/router/app_routes.dart';
import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/user/profile/domain/models/baby_model.dart';
import 'package:biberon/features/user/profile/presentation/screens/babies/bloc/babies_bloc.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class BabiesPage extends StatelessWidget {
  const BabiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (BabiesBloc bloc) =>
          bloc.state.status == FormzSubmissionStatus.inProgress,
    );
    return BlocListener<BabiesBloc, BabiesState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          Toast.showToast(
            context,
            'Bebeklerim yüklendi.',
            ToastType.success,
          );
        } else if (state.status == FormzSubmissionStatus.failure) {
          Toast.showToast(
            context,
            'Bebekler yüklenirken bir hata oluştu.',
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
                  final List<Baby?> result =
                      context.watch<BabiesBloc>().state.babies;
                  if (result.isEmpty) {
                    return Opacity(
                      opacity: isLoading ? 0.5 : 1,
                      child: AbsorbPointer(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '''Ekranın sağ altındaki butona tıklayarak yeni bir bebek ekleyebilirsiniz. 🤰''',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 20,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<BabiesBloc>().add(
                              const BabiesEventLoadBabies(),
                            );
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: result.length,
                        itemBuilder: (context, index) => ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 100),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 10,
                            ),
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Text('${result[index]!.id}'),
                                    const SizedBox(),

                                    Text(
                                      result[index]!.name!.capitalize,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () {
                                            context.pushNamed(
                                              AppRoutes.baby,
                                              queryParameters: {
                                                'babyId': result[index]!
                                                    .id
                                                    .toString(),
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.edit_rounded),
                                        ),
                                        IconButton(
                                          color: Colors.red,
                                          onPressed: () async {
                                            await showDialog<void>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Bebeği Sil ❗️',
                                                  ),
                                                  content: const Text(
                                                    '''Bu bebeği silmek istediğinize emin misiniz?\nBu işlem geri alınamaz!''',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        context.pop();
                                                      },
                                                      child:
                                                          const Text('Hayır'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        context
                                                            .read<
                                                                // ignore: lines_longer_than_80_chars
                                                                BabiesBloc>()
                                                            .add(
                                                              // ignore: lines_longer_than_80_chars
                                                              BabiesEventDeleteBaby(
                                                                result[index]!
                                                                    .id!,
                                                              ),
                                                            );
                                                        await context
                                                            // ignore: lines_longer_than_80_chars
                                                            .pushNamed(
                                                          AppRoutes.babies,
                                                        );
                                                      },
                                                      child: const Text('Evet'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:
                                              const Icon(Icons.delete_rounded),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
          onPressed: () {
            context.pushNamed(
              AppRoutes.baby,
            );
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}

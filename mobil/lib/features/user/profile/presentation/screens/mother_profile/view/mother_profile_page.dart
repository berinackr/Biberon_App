import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/bloc/mother_profile_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class MotherProfilePage extends StatelessWidget {
  const MotherProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
          (MotherProfileBloc bloc) => bloc.state.status,
        ) ==
        FormzSubmissionStatus.inProgress;
    return BlocListener<MotherProfileBloc, MotherProfileState>(
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
        } else if (state.status == FormzSubmissionStatus.success &&
            state.isEdited == true) {
          Toast.showToast(
            context,
            state.statusMessage ?? 'Profil bilgileri düzenlendi.',
            ToastType.success,
          );
          context
              .read<MotherProfileBloc>()
              .add(const ClearNotificationStates());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Text('Profil Bilgileri'),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Stack(
                  children: [
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
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SingleChildScrollView(
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.9,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                        top: 30,
                                        bottom: 20,
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: Column(
                                        children: [
                                          ImageContaier(),
                                          SizedBox(height: 20),
                                          NameTextInput(),
                                          SizedBox(height: 20),
                                          DatePicker(),
                                          SizedBox(height: 20),
                                          CityPicker(),
                                          SizedBox(height: 20),
                                          BioTextInput(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SaveButton(),
                                ],
                              ),
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

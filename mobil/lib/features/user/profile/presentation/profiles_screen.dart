// ignore_for_file: require_trailing_commas

import 'package:biberon/features/user/profile/data/repository/profile_repository.dart';
import 'package:biberon/features/user/profile/presentation/screens/babies/bloc/babies_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/babies/view/babies_page.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/bloc/mother_profile_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/view/mother_profile_page.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancies/bloc/pregnancies_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancies/view/pregnancies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({required this.initialIndex, super.key});
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          // Başlık ve diğer app bar özelliklerini kaldırdık
          elevation: 0, // AppBar'ın gölgesini kaldırabiliriz
          backgroundColor:
              Colors.transparent, // Arka plan rengini şeffaf yapabiliriz
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
                kToolbarHeight), // TabBar'ın yüksekliğini ayarlayabilirsiniz
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10), // TabBar'ı yukarı taşımak için padding ekleyin
              child: const TabBar(
                tabs: [
                  Tab(text: 'Bebeğim'),
                  Tab(text: 'Profilim'),
                  Tab(text: 'Hamileliklerim'),
                ],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => BabiesBloc(
                profileRepository: context.read<ProfileRepository>(),
                logger: context.read<Talker>(),
              )..add(const BabiesEventLoadBabies()),
              child: const BabiesPage(),
            ),
            BlocProvider(
              create: (context) => MotherProfileBloc(
                profileRepository: context.read<ProfileRepository>(),
                logger: context.read<Talker>(),
              )..add(const GetUserProfile()),
              child: const MotherProfilePage(),
            ),
            BlocProvider(
              create: (context) => PregnanciesBloc(
                profileRepository: context.read<ProfileRepository>(),
                logger: context.read<Talker>(),
              )..add(const FetchPregnancies()),
              child: const PregnanciesPage(),
            ),
          ],
        ),
      ),
    );
  }
}

part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.navIndex = 0,
    this.status = HomeStatus.initial,
  });

  final HomeStatus status;
  final int navIndex;

  HomeState copyWith({
    HomeStatus? status,
    int? navIndex,
  }) {
    return HomeState(
      status: status ?? this.status,
      navIndex: navIndex ?? this.navIndex,
    );
  }

  @override
  List<Object?> get props => [
        status,
        navIndex,
      ];
}

final class HomeInitial extends HomeState {}

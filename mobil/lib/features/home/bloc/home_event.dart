part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class SignOutRequested extends HomeEvent {
  const SignOutRequested();
}

class NavIndexChanged extends HomeEvent {
  const NavIndexChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class Refresh extends HomeEvent {
  const Refresh();
}

part of 'mybaby_bloc.dart';

sealed class MybabyEvent extends Equatable {
  const MybabyEvent();

  @override
  List<Object> get props => [];
}

class Refresh extends MybabyEvent {
  const Refresh();
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mybaby_event.dart';
part 'mybaby_state.dart';

class MybabyBloc extends Bloc<MybabyEvent, MybabyState> {
  MybabyBloc() : super(const MybabyState()) {
    on<Refresh>(_onRefresh);
  }

  Future<void> _onRefresh(
    Refresh event,
    Emitter<MybabyState> emit,
  ) async {
    emit(state.copyWith());
  }
}

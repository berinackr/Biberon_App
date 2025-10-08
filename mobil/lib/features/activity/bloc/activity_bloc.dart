import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(const ActivityState()) {
    on<Refresh>(_onRefresh);
  }
}

Future<void> _onRefresh(
  Refresh event,
  Emitter<ActivityState> emit,
) async {}

import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/domain/models/authentication_failure.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required AuthenticationRepository authenticationRepository,
    required Talker logger,
  })  : _authenticationRepository = authenticationRepository,
        _logger = logger,
        super(const HomeState()) {
    on<SignOutRequested>(_onSignOutRequested);
    on<NavIndexChanged>(_onNavIndexChanged);
    on<Refresh>(_onRefresh);
  }

  final AuthenticationRepository _authenticationRepository;
  final Talker _logger;

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      await _authenticationRepository.signOut();
      emit(state.copyWith(status: HomeStatus.success));
    } on AuthenticationFailure catch (e, stackTrace) {
      _logger.error(e.message, e, stackTrace);
      emit(
        state.copyWith(
          status: HomeStatus.failure,
        ),
      );
    }
  }

  Future<void> _onNavIndexChanged(
    NavIndexChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(navIndex: event.index));
    _logger.info('Navigated to index ${event.index}');
  }

  Future<void> _onRefresh(
    Refresh event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    emit(state.copyWith(status: HomeStatus.success));
  }
}

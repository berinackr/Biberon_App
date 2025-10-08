import 'dart:async';
import 'package:biberon/features/local_storage/data/repository/shared_prefences_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required SharedPrefencesRepository localStorageRepository,
    required Talker logger,
  })  : _logger = logger,
        _onboardingRepository = localStorageRepository,
        super(const OnboardingState()) {
    on<PageChanged>(_onPageChanged);
    on<SetOnboardingShowed>(_setOnboardingShowed);
  }

  final Talker _logger;
  final SharedPrefencesRepository _onboardingRepository;

  FutureOr<void> _onPageChanged(
    PageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        isShowedBefore: state.isShowedBefore,
        pageNumber: event.pageIndex,
      ),
    );
    _logger.info('Onboarding page changed to ${event.pageIndex}');
  }

  FutureOr<void> _setOnboardingShowed(
    SetOnboardingShowed event,
    Emitter<OnboardingState> emit,
  ) async {
    _logger.info('Onboarding completed. Passing to login screen.');
    emit(
      state.copyWith(
        isShowedBefore: true,
      ),
    );
    await _onboardingRepository.setFirstTime();
  }
}

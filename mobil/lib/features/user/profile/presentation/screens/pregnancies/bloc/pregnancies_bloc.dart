import 'package:biberon/features/user/profile/data/repository/profile_repository.dart';
import 'package:biberon/features/user/profile/domain/models/pregnancy_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'pregnancies_event.dart';
part 'pregnancies_state.dart';

class PregnanciesBloc extends Bloc<PregnanciesEvent, PregnanciesState> {
  PregnanciesBloc({
    required ProfileRepository profileRepository,
    required Talker logger,
  })  : _profileRepository = profileRepository,
        _logger = logger,
        super(
          const PregnanciesState(),
        ) {
    on<FetchPregnancies>(_onFetchPregnancies);
    on<DeletePregnancy>(_onDeletePregnancy);
  }

  final ProfileRepository _profileRepository;
  final Talker _logger;

  Future<void> _onFetchPregnancies(
    FetchPregnancies event,
    Emitter<PregnanciesState> emit,
  ) async {
    _logger.info('Fetching pregnancies');
    emit(
      PregnanciesState(
        status: FormzSubmissionStatus.inProgress,
        page: event.page,
        order: event.order,
      ),
    );

    final result = await _profileRepository.getPregnancies(
      state.order,
      state.page,
    );

    result.fold(
      (failure) {
        _logger.error('Failed to fetch pregnancies', failure);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (r) {
        _logger.info('Pregnancies fetched');
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            pregnancies: r,
          ),
        );
      },
    );
  }

//_onDeletePregnancy
  Future<void> _onDeletePregnancy(
    DeletePregnancy event,
    Emitter<PregnanciesState> emit,
  ) async {
    _logger.info('Deleting pregnancy');
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );

    final result = await _profileRepository.deletePregnancy(
      pregnancyId: event.pregnancyId,
    );

    result.fold(
      (failure) {
        _logger.error('Failed to delete pregnancy', failure);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (r) {
        _logger.info('Pregnancy deleted');
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
          ),
        );
      },
    );
  }
}

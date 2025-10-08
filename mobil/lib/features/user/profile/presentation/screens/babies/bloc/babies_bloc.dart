import 'package:biberon/features/user/profile/data/repository/profile_repository.dart';
import 'package:biberon/features/user/profile/domain/models/baby_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'babies_event.dart';
part 'babies_state.dart';

// class BabiesBloc extends Bloc<BabiesEvent, BabiesState> {
//   BabiesBloc({
//     required ProfileRepository profileRepository,
//     required Talker logger,
//   })  : _profileRepository = profileRepository,
//         _logger = logger,
//         super(const BabiesState()) {
//     on<BabiesEventLoadBabies>(_onBabiesLoadBabies);
//     on<BabiesEventAddBaby>(_onBabiesAddBaby);
//     on<BabiesEventDeleteBaby>(_onBabiesDeleteBaby);
//   }

//   final ProfileRepository _profileRepository;
//   final Talker _logger;

//   Future<void> _onBabiesLoadBabies(
//     BabiesEventLoadBabies event,
//     Emitter<BabiesState> emit,
//   ) async {
//     emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

//     final result = await _profileRepository.getBabies(
//       event.order,
//       event.page,
//     );

//     result.fold(
//       (failure) {
//         emit(state.copyWith(
//           status: FormzSubmissionStatus.failure,
//           errorMessage: failure.message,
//         ));
//       },
//       (babies) {
//         emit(state.copyWith(
//           status: FormzSubmissionStatus.success,
//           babies: babies,
//         ));
//       },
//     );
//   }

class BabiesBloc extends Bloc<BabiesEvent, BabiesState> {
  BabiesBloc({
    required ProfileRepository profileRepository,
    required Talker logger,
  })  : _profileRepository = profileRepository,
        _logger = logger,
        super(const BabiesState()) {
    on<BabiesEventLoadBabies>(_onBabiesLoadBabies);
    on<BabiesEventDeleteBaby>(_onBabiesDeleteBaby);
  }

  final ProfileRepository _profileRepository;
  final Talker _logger;

  Future<void> _onBabiesLoadBabies(
    BabiesEventLoadBabies event,
    Emitter<BabiesState> emit,
  ) async {
    _logger.info('Fetching babies');
    emit(
      BabiesState(
        status: FormzSubmissionStatus.inProgress,
        page: event.page,
        order: event.order,
      ),
    );

    final result = await _profileRepository.getBabies(
      state.order,
      state.page,
    );

    result.fold(
      (failure) {
        _logger.error('Failed to fetch babies', failure.message);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (r) {
        _logger.info('Babies fetched');
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            babies: r,
          ),
        );
      },
    );
  }

  Future<void> _onBabiesDeleteBaby(
    BabiesEventDeleteBaby event,
    Emitter<BabiesState> emit,
  ) async {
    _logger.info('Deleting baby');
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );
    final result = await _profileRepository.deleteBaby(
      babyId: event.babyId,
    );

    result.fold(
      (failure) {
        _logger.error('Failed to delete baby', failure);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (r) {
        _logger.info('baby deleted');
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
          ),
        );
      },
    );
  }
}

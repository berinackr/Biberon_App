import 'package:biberon/common/errors/exception.dart';
import 'package:biberon/common/models/form_inputs/due_date.dart';
import 'package:biberon/common/models/form_inputs/last_period_date.dart';
import 'package:biberon/features/user/profile/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'pregnancy_event.dart';
part 'pregnancy_state.dart';

class PregnancyBloc extends Bloc<PregnancyEvent, PregnancyState> {
  PregnancyBloc({
    required ProfileRepository profileRepository,
    required Talker logger,
  })  : _profileRepository = profileRepository,
        _logger = logger,
        super(const PregnancyState()) {
    on<FetchPregnancy>(_onFetchPregnancy);
    on<AddPregnancy>(_onAddPregnancy);
    on<UpdatePregnancy>(_onUpdatePregnancy);
    on<DeletePregnancy>(_onDeletePregnancy);
    on<FieldChangedDueDate>(_onFieldChangedDueDate);
    on<FieldChangedBirthGiven>(_onFieldChangedBirthGiven);
    on<FieldChangedType>(_onFieldChangedType);
    on<FieldChangedDeliveryType>(_onFieldChangedDeliveryType);
    on<FieldChangedNotes>(_onFieldChangedNotes);
    on<FieldChangedGender>(_onFieldChangedGender);
    on<FieldChangedEndDate>(_onFieldChangedEndDate);
    on<FieldChangedLastPeriodDate>(_onFieldChangedLastPeriodDate);
    on<FieldChangedIKnowDueDate>(_onFieldChangedIKnowDueDate);
    on<ClearNotificationStates>(_clearNotificationStates);
    on<CompletePregnancy>(_onCompletePregnancy);
  }

  final ProfileRepository _profileRepository;
  final Talker _logger;

  Future<void> _onFetchPregnancy(
    FetchPregnancy event,
    Emitter<PregnancyState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        pregnancyId: event.pregnancyId,
      ),
    );

    if (state.pregnancyId != null) {
      _logger.info('Fetching pregnancy');
      final result = await _profileRepository.getPregnancy(
        pregnancyId: event.pregnancyId!,
        includeFetuses: true,
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (Pregnancy pregnancy) => emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            birthGiven: pregnancy.birthGiven,
            dueDate: DueDate.dirty(pregnancy.dueDate),
            lastPeriodDate: LastPeriodDate.dirty(
              pregnancy.dueDate!.subtract(
                const Duration(days: 280),
              ),
            ),
            type: pregnancy.type,
            deliveryType: pregnancy.deliveryType,
            notes: () => pregnancy.notes,
            endDate: pregnancy.endDate,
            fetuses: pregnancy.fetuses,
            isActive: pregnancy.isActive,
            pregnancyId: pregnancy.id,
            iKnowDueDate: true,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      );
    }
  }

  Future<void> _onAddPregnancy(
    AddPregnancy event,
    Emitter<PregnancyState> emit,
  ) async {
    _logger.info('Adding pregnancy');
    late final Either<AppException, Pregnancy> result;
    if (state.isValid) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
      if (!state.iKnowDueDate) {
        result = await _profileRepository.addPregnancy(
          pregnancyPostModel: PregnancyPostModel(
            birthGiven: false,
            lastPeriodDate: state.lastPeriodDate!.value,
            type: state.type,
            deliveryType: state.deliveryType,
            notes: state.notes,
            fetuses: List.generate(
              state.fetuses!.length,
              (index) => FetusPostModel(gender: state.fetuses![index].gender),
            ),
          ),
        );
      } else {
        result = await _profileRepository.addPregnancy(
          pregnancyPostModel: PregnancyPostModel(
            dueDate: state.dueDate!.value,
            birthGiven: false,
            type: state.type,
            deliveryType: state.deliveryType,
            notes: state.notes,
            fetuses: List.generate(
              state.fetuses!.length,
              (index) => FetusPostModel(gender: state.fetuses![index].gender),
            ),
          ),
        );
      }
      result.fold((l) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: l.message,
          ),
        );
      }, (pregnancy) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            birthGiven: pregnancy.birthGiven,
            dueDate: DueDate.dirty(pregnancy.dueDate),
            lastPeriodDate: LastPeriodDate.dirty(
              pregnancy.dueDate!.subtract(
                const Duration(days: 280),
              ),
            ),
            type: pregnancy.type,
            deliveryType: pregnancy.deliveryType,
            notes: () => pregnancy.notes,
            endDate: pregnancy.endDate,
            fetuses: pregnancy.fetuses,
            isActive: pregnancy.isActive,
            pregnancyId: pregnancy.id,
            iKnowDueDate: true,
            isAdded: true,
          ),
        );
      });
    } else {
      if (state.dueDate!.displayError == null &&
          state.iKnowDueDate &&
          state.dueDate!.value == null) {
        emit(
          state.copyWith(
            dueDate: const DueDate.dirty(null),
          ),
        );
      }
      if (state.lastPeriodDate!.displayError == null &&
          !state.iKnowDueDate &&
          state.lastPeriodDate!.value == null) {
        emit(
          state.copyWith(
            lastPeriodDate: const LastPeriodDate.dirty(null),
          ),
        );
      }
    }
  }

  Future<void> _onUpdatePregnancy(
    UpdatePregnancy event,
    Emitter<PregnancyState> emit,
  ) async {
    if (state.isValid) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
      _logger.info('Updating pregnancy');
      final result = await _profileRepository.updatePregnancy(
        pregnancyId: state.pregnancyId!,
        pregnancyPostModel: PregnancyPostModel(
          dueDate: state.iKnowDueDate ? state.dueDate!.value : null,
          birthGiven: state.birthGiven ?? false,
          type: state.type,
          deliveryType: state.deliveryType,
          notes: state.notes,
          lastPeriodDate:
              state.iKnowDueDate ? null : state.lastPeriodDate!.value,
          fetuses: List<FetusPostModel>.generate(
            state.fetuses?.length ?? 0,
            (index) => FetusPostModel(
              gender: state.fetuses![index].gender,
            ),
          ),
        ),
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: failure.message,
            ),
          );
        },
        (pregnancy) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
              birthGiven: pregnancy.birthGiven,
              dueDate: DueDate.dirty(pregnancy.dueDate),
              lastPeriodDate: LastPeriodDate.dirty(pregnancy.lastPeriodDate),
              type: pregnancy.type,
              deliveryType: pregnancy.deliveryType,
              notes: () => pregnancy.notes,
              endDate: pregnancy.endDate,
              fetuses: pregnancy.fetuses,
              isActive: pregnancy.isActive,
              pregnancyId: pregnancy.id,
              iKnowDueDate: true,
              isUpdated: true,
            ),
          );
        },
      );
    } else {
      if (state.dueDate!.displayError == null &&
          state.iKnowDueDate &&
          state.dueDate!.value == null) {
        emit(
          state.copyWith(
            dueDate: const DueDate.dirty(null),
          ),
        );
      }
      if (state.lastPeriodDate!.displayError == null &&
          !state.iKnowDueDate &&
          state.lastPeriodDate!.value == null) {
        emit(
          state.copyWith(
            lastPeriodDate: const LastPeriodDate.dirty(null),
          ),
        );
      }
    }
  }

  Future<void> _onDeletePregnancy(
    DeletePregnancy event,
    Emitter<PregnancyState> emit,
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

  void _onFieldChangedDueDate(
    FieldChangedDueDate event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        dueDate: DueDate.dirty(event.dueDate),
      ),
    );
  }

  void _onFieldChangedBirthGiven(
    FieldChangedBirthGiven event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        birthGiven: event.birthGiven,
      ),
    );
  }

  void _onFieldChangedType(
    FieldChangedType event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        type: event.type,
        fetuses: List<Fetus>.generate(
          lType.indexOf(event.type!) + 1,
          (index) => Fetus(id: index, gender: 'UNKNOWN'),
        ),
      ),
    );
  }

  void _onFieldChangedDeliveryType(
    FieldChangedDeliveryType event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        deliveryType: event.deliveryType,
      ),
    );
  }

  void _onFieldChangedNotes(
    FieldChangedNotes event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        notes: event.notes == null ? () => null : () => event.notes!,
      ),
    );
  }

  void _onFieldChangedGender(
    FieldChangedGender event,
    Emitter<PregnancyState> emit,
  ) {
    final updatedFetusList = List.generate(
      state.fetuses!.length,
      (index) => Fetus(
        id: state.fetuses![index].id,
        gender:
            index == event.index ? event.gender : state.fetuses![index].gender,
      ),
    );

    emit(
      state.copyWith(
        fetuses: updatedFetusList,
      ),
    );
  }

  void _onFieldChangedEndDate(
    FieldChangedEndDate event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        endDate: event.endDate,
      ),
    );
  }

  void _onFieldChangedLastPeriodDate(
    FieldChangedLastPeriodDate event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        lastPeriodDate: LastPeriodDate.dirty(event.lastPeriodDate),
      ),
    );
  }

  void _onFieldChangedIKnowDueDate(
    FieldChangedIKnowDueDate event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        iKnowDueDate: event.iKnowDueDate,
      ),
    );
  }

  void _clearNotificationStates(
    ClearNotificationStates event,
    Emitter<PregnancyState> emit,
  ) {
    emit(
      state.copyWith(
        isUpdated: false,
        isAdded: false,
        isCompleted: false,
      ),
    );
  }

  Future<void> _onCompletePregnancy(
    CompletePregnancy event,
    Emitter<PregnancyState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );
    _logger.info('Updating pregnancy');
    final result = await _profileRepository.completeActivePregnancy(
      birthDate: event.birthDate,
    );

    result.fold((failure) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: failure.message,
          isCompleted: false,
        ),
      );
    }, (r) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          isCompleted: true,
        ),
      );
    });
  }
}

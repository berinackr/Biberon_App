import 'package:biberon/common/models/form_inputs/birth_height.dart';
import 'package:biberon/common/models/form_inputs/birth_weight.dart';
import 'package:biberon/common/models/form_inputs/date_of_birth.dart';
import 'package:biberon/common/models/form_inputs/form_inputs.dart';
import 'package:biberon/common/models/form_inputs/gender.dart';
import 'package:biberon/common/models/form_inputs/notes.dart';
import 'package:biberon/features/user/profile/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'baby_event.dart';
part 'baby_state.dart';

class BabyBloc extends Bloc<BabyEvent, BabyState> {
  BabyBloc({
    required ProfileRepository profileRepository,
    required Talker logger,
  })  : _profileRepository = profileRepository,
        _logger = logger,
        super(const BabyState()) {
    on<BabyEventLoad>(_onBabyEventLoad);
    on<BabyEventAddBaby>(_onBabyEventAddBaby);
    on<BabyEventUpdateBaby>(_onBabyEventUpdateBaby);
    on<BabyEventDeleteBaby>(_onBabyEventDeleteBaby);
    on<BabyEventGenderChanged>(_onBabyEventGenderChanged);
    on<BabyEventNameChanged>(_onBabyEventNameChanged);
    on<BabyEventDateOfBirthChanged>(_onBabyEventDateOfBirthChanged);
    on<BabyEventBirthTimeChanged>(_onBabyEventBirthTimeChanged);
    on<BabyEventBirthWeightChanged>(_onBabyEventBirthWeightChanged);
    on<BabyEventBirthHeightChanged>(_onBabyEventBirthHeightChanged);
    on<BabyEventNotesChanged>(_onBabyEventNotesChanged);
    on<ClearNotificationStates>(_clearNotificationStates);
  }

  final ProfileRepository _profileRepository;
  final Talker _logger;

  Future<void> _onBabyEventLoad(
    BabyEventLoad event,
    Emitter<BabyState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        babyId: event.babyId,
      ),
    );

    if (state.babyId != null) {
      final now = DateTime.now();
      final result = await _profileRepository.getBaby(
        event.babyId!,
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (Baby baby) => emit(
          state.copyWith(
            babyId: baby.id,
            name: Name.dirty(baby.name!),
            status: FormzSubmissionStatus.success,
            gender: Gender.dirty(baby.gender!),
            dateOfBirth: DateOfBirth.dirty(baby.dateOfBirth),
            birthTime: baby.birthTime == null
                ? null
                : DateTime(
                    now.year,
                    now.month,
                    now.day,
                    int.parse(baby.birthTime!.substring(0, 2)),
                    int.parse(baby.birthTime!.substring(3, 5)),
                  ),
            birthHeight: BirthHeight.dirty(baby.birthHeight),
            birthWeight: BirthWeight.dirty(baby.birthWeight),
            notes: Notes.dirty(baby.notes),
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

  Future<void> _onBabyEventAddBaby(
    BabyEventAddBaby event,
    Emitter<BabyState> emit,
  ) async {
    final numberFormat = NumberFormat('00');
    _logger.info('BabyBloc: _onBabyEventAddBaby');

    // Durumu FormzSubmissionStatus.inProgress ile güncelle
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    // Eğer durum geçerliyse bebek eklemeye devam et
    if (state.isValid) {
      final result = await _profileRepository.addBaby(
        BabyPostModel(
          gender: state.gender.value,
          name: state.name.value,
          dateOfBirth: state.dateOfBirth.value,
          birthTime: state.birthTime == null
              ? null
              : '''
${numberFormat.format(state.birthTime!.hour)}:${numberFormat.format(state.birthTime!.minute)}'''
                  .trim(),
          birthWeight: state.birthWeight?.value,
          birthHeight: state.birthHeight?.value,
          notes: state.notes?.value,
        ),
      );

      // Sonuç başarılı ise, durumu başarılı olarak güncelle ve
      //bebek detaylarını doldur
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
          _logger.error(
            // ignore: lines_longer_than_80_chars
            'BabyBloc: _onBabyEventAddBaby, error while adding baby: ${failure.message}',
          );
        },
        (r) {
          // Başarılı sonuç, durumu güncelle ve bebek detaylarını doldur
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
              babyId: r.id,
              baby: r,
            ),
          );
          _logger.info(
            'BabyBloc: _onBabyEventAddBaby, baby added, babyId: ${r.id}',
          );
        },
      );
    } else {
      // Eğer durum geçerli değilse, hata durumu yayınla
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Geçersiz bebek bilgisi',
        ),
      );
      _logger.error('BabyBloc: _onBabyEventAddBaby, invalid baby information');
    }
  }

  Future<void> _onBabyEventUpdateBaby(
    BabyEventUpdateBaby event,
    Emitter<BabyState> emit,
  ) async {
    final numberFormat = NumberFormat('00');
    _logger.info('BabyBloc: _onBabyEventUpdateBaby');
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    if (state.isValid) {
      final result = await _profileRepository.updateBaby(
        state.babyId!,
        BabyPostModel(
          gender: state.gender.value,
          name: state.name.value,
          dateOfBirth: state.dateOfBirth.value,
          birthTime: state.birthTime == null
              ? null
              : '''
${numberFormat.format(state.birthTime!.hour)}:${numberFormat.format(state.birthTime!.minute)}'''
                  .trim(),
          birthWeight: state.birthWeight?.value,
          birthHeight: state.birthHeight?.value,
          notes: state.notes?.value,
        ),
      );
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
          _logger.error(
            '''BabyBloc: _onBabyEventUpdateBaby, error while updating baby: ${failure.message}''',
          );
        },
        (baby) {
          emit(
            state.copyWith(
              baby: baby,
              status: FormzSubmissionStatus.success,
            ),
          );
          _logger.info(
            'BabyBloc: _onBabyEventUpdateBaby, baby updated r.id: ${baby.id}',
          );
        },
      );
    }
  }

  Future<void> _onBabyEventDeleteBaby(
    BabyEventDeleteBaby event,
    Emitter<BabyState> emit,
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
        _logger.info('Baby deleted');
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
          ),
        );
      },
    );
  }

  void _onBabyEventGenderChanged(
    BabyEventGenderChanged event,
    Emitter<BabyState> emit,
  ) {
    final gender = Gender.dirty(event.gender);
    emit(
      state.copyWith(
        gender: gender,
      ),
    );
  }

  void _onBabyEventNameChanged(
    BabyEventNameChanged event,
    Emitter<BabyState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
      ),
    );
  }

  void _onBabyEventDateOfBirthChanged(
    BabyEventDateOfBirthChanged event,
    Emitter<BabyState> emit,
  ) {
    final dateOfBirth = DateOfBirth.dirty(event.dateOfBirth);
    emit(
      state.copyWith(
        dateOfBirth: dateOfBirth,
      ),
    );
  }

  void _onBabyEventBirthTimeChanged(
    BabyEventBirthTimeChanged event,
    Emitter<BabyState> emit,
  ) {
    emit(
      state.copyWith(
        birthTime: event.birthTime,
      ),
    );
  }

  void _onBabyEventBirthWeightChanged(
    BabyEventBirthWeightChanged event,
    Emitter<BabyState> emit,
  ) {
    final birthWeight = BirthWeight.dirty(event.birthWeight);
    emit(
      state.copyWith(
        birthWeight: birthWeight,
      ),
    );
  }

  void _onBabyEventBirthHeightChanged(
    BabyEventBirthHeightChanged event,
    Emitter<BabyState> emit,
  ) {
    final birthHeight = BirthHeight.dirty(event.birthHeight);
    emit(
      state.copyWith(
        birthHeight: birthHeight,
      ),
    );
  }

  void _onBabyEventNotesChanged(
    BabyEventNotesChanged event,
    Emitter<BabyState> emit,
  ) {
    final notes = Notes.dirty(event.notes);
    emit(
      state.copyWith(
        notes: notes,
      ),
    );
  }

  void _clearNotificationStates(
    ClearNotificationStates event,
    Emitter<BabyState> emit,
  ) {
    emit(
      state.copyWith(
        isUpdated: false,
        isAdded: false,
      ),
    );
  }
}

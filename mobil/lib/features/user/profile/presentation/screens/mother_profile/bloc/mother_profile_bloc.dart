import 'package:biberon/common/data/cities_of_turkey.dart';
import 'package:biberon/common/models/form_inputs/city_input.dart';
import 'package:biberon/common/models/form_inputs/date_of_birth_mother.dart';
import 'package:biberon/common/models/form_inputs/form_inputs.dart';
import 'package:biberon/features/user/profile/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'mother_profile_event.dart';
part 'mother_profile_state.dart';

class MotherProfileBloc extends Bloc<MotherProfileEvent, MotherProfileState> {
  MotherProfileBloc({
    required ProfileRepository profileRepository,
    required Talker logger,
  })  : _profileRepository = profileRepository,
        _logger = logger,
        super(const MotherProfileState()) {
    on<GetUserProfile>(_getUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateUserBio>(_onUpdateUserBio);
    on<UpdateUserName>(_onUpdateUserName);
    on<UpdateUserDateOfBirth>(_onUpdateUserDateOfBirth);
    on<DeleteUserDateOfBirth>(_onDeleteUserDateOfBirth);
    on<UpdateUserCity>(_onUpdateUserCity);
    on<DeleteUserCity>(_onDeleteUserCity);
    on<ClearNotificationStates>(_clearNotificationStates);
  }

  final ProfileRepository _profileRepository;
  final Talker _logger;

  Future<void> _getUserProfile(
    GetUserProfile event,
    Emitter<MotherProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );
    final result = await _profileRepository.getUserProfile();

    result.fold(
      (failure) {
        _logger.error('Failed to fetch user profile', failure);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.toString(),
          ),
        );
      },
      (data) {
        _logger.info('User profile fetched');
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.initial,
            name:
                data.name == null ? const Name.pure() : Name.dirty(data.name!),
            bio: data.bio == null ? const Bio.pure() : Bio.dirty(data.bio!),
            city: data.cityId == null
                ? const CityInput.pure()
                : CityInput.dirty(
                    citiesOfTurkey[data.cityId!],
                  ),
            dateOfBirth: data.dateOfBirth == null
                ? const DateOfBirthMother.pure()
                : DateOfBirthMother.dirty(
                    data.dateOfBirth,
                  ),
          ),
        );
      },
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<MotherProfileState> emit,
  ) async {
    _logger.info('Update mother profile requested');

    if (state.isValid) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
      final result = await _profileRepository.updateUserProfile(
        UpdateProfilePostModel(
          name: state.name.value.isEmpty ? null : state.name.value,
          bio: state.bio.value.isEmpty ? null : state.bio.value,
          dateOfBirth: state.dateOfBirth.value,
          cityId: citiesOfTurkey.indexOf(state.city.value) == 0
              ? null
              : citiesOfTurkey.indexOf(state.city.value),
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.toString(),
          ),
        ),
        (data) => emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            statusMessage: 'Profiliniz başarıyla güncellendi',
            isEdited: true,
          ),
        ),
      );
    }
  }

  void _onUpdateUserBio(
    UpdateUserBio event,
    Emitter<MotherProfileState> emit,
  ) {
    final bio = Bio.dirty(event.bio.trim());
    emit(
      state.copyWith(
        bio: bio,
      ),
    );
  }

  void _onUpdateUserCity(
    UpdateUserCity event,
    Emitter<MotherProfileState> emit,
  ) {
    final city = CityInput.dirty(citiesOfTurkey[event.city]);
    emit(state.copyWith(city: city));
  }

  void _onDeleteUserCity(
    DeleteUserCity event,
    Emitter<MotherProfileState> emit,
  ) {
    emit(state.copyWith(city: const CityInput.pure()));
  }

  void _onUpdateUserDateOfBirth(
    UpdateUserDateOfBirth event,
    Emitter<MotherProfileState> emit,
  ) {
    final dateOfBirth = DateOfBirthMother.dirty(event.dateOfBirth);
    emit(state.copyWith(dateOfBirth: dateOfBirth));
  }

  void _onDeleteUserDateOfBirth(
    DeleteUserDateOfBirth event,
    Emitter<MotherProfileState> emit,
  ) {
    emit(state.copyWith(dateOfBirth: const DateOfBirthMother.pure()));
  }

  void _onUpdateUserName(
    UpdateUserName event,
    Emitter<MotherProfileState> emit,
  ) {
    final name = Name.dirty(event.name.trim());
    emit(state.copyWith(name: name));
  }

  void _clearNotificationStates(
    ClearNotificationStates event,
    Emitter<MotherProfileState> emit,
  ) {
    emit(
      state.copyWith(
        // ignore: avoid_redundant_argument_values
        isEdited: false,
      ),
    );
  }
}

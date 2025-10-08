part of 'mother_profile_bloc.dart';

class MotherProfileState extends Equatable {
  const MotherProfileState({
    this.status = FormzSubmissionStatus.initial,
    this.name = const Name.pure(),
    this.bio = const Bio.pure(),
    this.dateOfBirth = const DateOfBirthMother.pure(),
    this.city = const CityInput.pure(),
    this.errorMessage,
    this.statusMessage,
    this.isEdited = false,
  });
  final bool isEdited;
  final FormzSubmissionStatus status;
  final Name name;
  final Bio bio;
  final DateOfBirthMother dateOfBirth;
  final CityInput city;
  final String? errorMessage;
  final String? statusMessage;
  bool get isValid =>
      name.isValid && bio.isValid && dateOfBirth.isValid && city.isValid;

  MotherProfileState copyWith({
    FormzSubmissionStatus? status,
    Name? name,
    Bio? bio,
    DateOfBirthMother? dateOfBirth,
    CityInput? city,
    String? errorMessage,
    String? statusMessage,
    bool isEdited = false,
  }) {
    return MotherProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      city: city ?? this.city,
      errorMessage: errorMessage ?? this.errorMessage,
      statusMessage: statusMessage ?? this.statusMessage,
      isEdited: isEdited,
    );
  }

  @override
  List<Object?> get props => [
        status,
        name,
        bio,
        dateOfBirth,
        city,
        errorMessage,
        statusMessage,
        isEdited,
      ];
}

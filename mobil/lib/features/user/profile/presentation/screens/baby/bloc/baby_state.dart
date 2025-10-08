part of 'baby_bloc.dart';

List<String> lGender = ['BOY', 'GIRL'];

// lGender converter extension method

extension GenderExtension on String {
  String get toTurkishGender {
    switch (this) {
      case 'BOY':
        return 'Erkek ♂︎';
      case 'GIRL':
        return 'Kız ♀︎';
      default:
        return '??';
    }
  }
}

class BabyState extends Equatable {
  const BabyState({
    this.gender = const Gender.pure(),
    this.name = const Name.pure(),
    this.babyId,
    this.birthWeight = const BirthWeight.pure(),
    this.birthHeight = const BirthHeight.pure(),
    this.dateOfBirth = const DateOfBirth.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.baby,
    this.birthTime,
    this.notes = const Notes.pure(),
    this.errorMessage,
    this.isUpdated = false,
    this.isAdded = false,
  });

  bool get isValid {
    return name.isValid && dateOfBirth.isValid && gender.isValid;
  }

  final int? babyId;
  final FormzSubmissionStatus? status;
  final Baby? baby;
  final Gender gender;
  final Name name;
  final DateOfBirth dateOfBirth;
  final DateTime? birthTime;
  final BirthWeight? birthWeight;
  final BirthHeight? birthHeight;
  final Notes? notes;
  final String? errorMessage;
  final bool isUpdated;
  final bool isAdded;

  @override
  List<Object?> get props => [
        babyId,
        status,
        baby,
        gender,
        name,
        dateOfBirth,
        birthTime,
        birthWeight,
        birthHeight,
        notes,
        errorMessage,
        isUpdated,
        isAdded,
      ];

  BabyState copyWith({
    int? babyId,
    FormzSubmissionStatus? status,
    Baby? baby,
    Gender? gender,
    DateOfBirth? dateOfBirth,
    DateTime? birthTime,
    BirthWeight? birthWeight,
    BirthHeight? birthHeight,
    Notes? notes,
    Name? name,
    String? errorMessage,
    bool? isUpdated,
    bool? isAdded,
  }) {
    return BabyState(
      babyId: babyId ?? this.babyId,
      status: status ?? this.status,
      baby: baby ?? this.baby,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      birthTime: birthTime ?? this.birthTime,
      birthWeight: birthWeight ?? this.birthWeight,
      birthHeight: birthHeight ?? this.birthHeight,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdated: isUpdated ?? this.isUpdated,
      isAdded: isAdded ?? this.isAdded,
    );
  }
}

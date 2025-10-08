part of 'baby_bloc.dart';

sealed class BabyEvent extends Equatable {
  const BabyEvent();

  @override
  List<Object?> get props => [];
}

class BabyEventLoad extends BabyEvent {
  const BabyEventLoad(this.babyId);
  final int? babyId;

  @override
  List<Object?> get props => [babyId];
}

class BabyEventUpdateBaby extends BabyEvent {
  const BabyEventUpdateBaby();

  @override
  List<Object?> get props => [];
}

class BabyEventAddBaby extends BabyEvent {
  const BabyEventAddBaby();

  @override
  List<Object?> get props => [];
}

class BabyEventDeleteBaby extends BabyEvent {
  const BabyEventDeleteBaby(this.babyId);
  final int babyId;

  @override
  List<Object> get props => [babyId];
}

class BabyEventResetData extends BabyEvent {
  const BabyEventResetData();

  @override
  List<Object?> get props => [];
}

//Input Changed Events
class BabyEventGenderChanged extends BabyEvent {
  const BabyEventGenderChanged(this.gender);
  final String gender;

  @override
  List<Object?> get props => [gender];
}

class BabyEventNameChanged extends BabyEvent {
  const BabyEventNameChanged(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}

class BabyEventDateOfBirthChanged extends BabyEvent {
  const BabyEventDateOfBirthChanged(this.dateOfBirth);
  final DateTime? dateOfBirth;

  @override
  List<Object?> get props => [dateOfBirth];
}

class BabyEventBirthTimeChanged extends BabyEvent {
  const BabyEventBirthTimeChanged(this.birthTime);
  final DateTime? birthTime;

  @override
  List<Object?> get props => [birthTime];
}

class BabyEventBirthWeightChanged extends BabyEvent {
  const BabyEventBirthWeightChanged(this.birthWeight);
  final int? birthWeight;

  @override
  List<Object?> get props => [birthWeight];
}

class BabyEventBirthHeightChanged extends BabyEvent {
  const BabyEventBirthHeightChanged(this.birthHeight);
  final int? birthHeight;

  @override
  List<Object?> get props => [birthHeight];
}

class BabyEventNotesChanged extends BabyEvent {
  const BabyEventNotesChanged(this.notes);
  final String? notes;

  @override
  List<Object?> get props => [notes];
}

class ClearNotificationStates extends BabyEvent {
  const ClearNotificationStates();
}

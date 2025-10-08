part of 'pregnancy_bloc.dart';

sealed class PregnancyEvent extends Equatable {
  const PregnancyEvent();

  @override
  List<Object?> get props => [];
}

class FetchPregnancy extends PregnancyEvent {
  const FetchPregnancy(this.pregnancyId);

  final int? pregnancyId;
  @override
  List<Object?> get props => [pregnancyId];
}

class AddPregnancy extends PregnancyEvent {
  const AddPregnancy();
}

class UpdatePregnancy extends PregnancyEvent {
  const UpdatePregnancy();

  @override
  List<Object> get props => [];
}

class DeletePregnancy extends PregnancyEvent {
  const DeletePregnancy(this.pregnancyId);

  final int pregnancyId;

  @override
  List<Object> get props => [pregnancyId];
}

class FieldChangedDueDate extends PregnancyEvent {
  const FieldChangedDueDate(this.dueDate);

  final DateTime dueDate;

  @override
  List<Object> get props => [dueDate];
}

class FieldChangedBirthGiven extends PregnancyEvent {
  const FieldChangedBirthGiven({required this.birthGiven});

  final bool birthGiven;

  @override
  List<Object> get props => [birthGiven];
}

class FieldChangedType extends PregnancyEvent {
  const FieldChangedType(this.type);

  final String? type;

  @override
  List<Object?> get props => [type];
}

class FieldChangedDeliveryType extends PregnancyEvent {
  const FieldChangedDeliveryType(this.deliveryType);

  final String? deliveryType;

  @override
  List<Object?> get props => [deliveryType];
}

class FieldChangedNotes extends PregnancyEvent {
  const FieldChangedNotes(this.notes);

  final String? notes;

  @override
  List<Object?> get props => [notes];
}

class FieldChangedGender extends PregnancyEvent {
  const FieldChangedGender(this.gender, this.index);

  final String gender;
  final int index;

  @override
  List<Object> get props => [gender, index];
}

class FieldChangedEndDate extends PregnancyEvent {
  const FieldChangedEndDate(this.endDate);

  final DateTime endDate;

  @override
  List<Object> get props => [endDate];
}

class FieldChangedLastPeriodDate extends PregnancyEvent {
  const FieldChangedLastPeriodDate(this.lastPeriodDate);

  final DateTime? lastPeriodDate;

  @override
  List<Object?> get props => [lastPeriodDate];
}

class FieldChangedIKnowDueDate extends PregnancyEvent {
  const FieldChangedIKnowDueDate({required this.iKnowDueDate});

  final bool iKnowDueDate;

  @override
  List<Object> get props => [iKnowDueDate];
}

class ClearNotificationStates extends PregnancyEvent {
  const ClearNotificationStates();
}

class CompletePregnancy extends PregnancyEvent {
  const CompletePregnancy({
    required this.birthDate,
  });

  final DateTime birthDate;

  @override
  List<Object> get props => [birthDate];
}

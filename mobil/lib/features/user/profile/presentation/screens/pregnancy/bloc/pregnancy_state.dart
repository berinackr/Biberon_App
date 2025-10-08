part of 'pregnancy_bloc.dart';

List<String> lType = ['SINGLE', 'TWIN'];

// ltype converter extension method to turkish eg 'SINGLE' -> 'Tek'
extension TypeExtension on String {
  String get toTurkishType {
    switch (this) {
      case 'SINGLE':
        return 'Tek ⚆';
      case 'TWIN':
        return 'İkiz ⚇';
      default:
        return '??';
    }
  }
}

List<String> lDeliveryType = ['VAGINAL', 'CESAREAN', 'UNKNOWN'];

// lDeliveryType converter extension method to turkish eg 'VAGINAL' -> 'Normal'
extension DeliveryTypeExtension on String {
  String get toTurkishDeliveryType {
    switch (this) {
      case 'VAGINAL':
        return 'Normal ';
      case 'CESAREAN':
        return 'Sezaryen';
      case 'UNKNOWN':
        return 'Bilinmiyor ⚬';
      default:
        return '??';
    }
  }
}

List<String> lGender = ['BOY', 'GIRL', 'UNKNOWN'];

// lGender converter extension method

extension GenderExtension on String {
  String get toTurkishGender {
    switch (this) {
      case 'BOY':
        return 'Erkek ♂︎';
      case 'GIRL':
        return 'Kız ♀︎';
      case 'UNKNOWN':
        return 'Bilinmiyor ⚬';
      default:
        return '??';
    }
  }
}

class PregnancyState extends Equatable {
  const PregnancyState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.pregnancyId,
    this.isActive,
    this.dueDate = const DueDate.pure(),
    this.birthGiven,
    this.type = 'SINGLE',
    this.deliveryType = 'UNKNOWN',
    this.notes,
    this.endDate,
    this.lastPeriodDate = const LastPeriodDate.pure(),
    this.fetuses = const [Fetus(id: 0, gender: 'UNKNOWN')],
    this.iKnowDueDate = true,
    // notification states
    this.isUpdated = false,
    this.isAdded = false,
    this.isCompleted = false,
  });

  final FormzSubmissionStatus? status;
  final String? errorMessage;
  final bool? isActive;
  final int? pregnancyId;
  final bool? birthGiven;
  final LastPeriodDate? lastPeriodDate;
  final DateTime? endDate;
  final DueDate? dueDate;
  final String type;
  final String? deliveryType;
  final String? notes;
  final List<Fetus>? fetuses;
  final bool iKnowDueDate;
  final bool isUpdated;
  final bool isAdded;
  final bool isCompleted;
  bool get isValid {
    if (iKnowDueDate) {
      return dueDate!.isValid;
    } else {
      return lastPeriodDate!.isValid;
    }
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isActive,
        pregnancyId,
        birthGiven,
        lastPeriodDate,
        endDate,
        dueDate,
        type,
        deliveryType,
        notes,
        fetuses,
        iKnowDueDate,
        isUpdated,
        isAdded,
        isCompleted,
      ];

  PregnancyState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool? isActive,
    int? pregnancyId,
    bool? birthGiven,
    LastPeriodDate? lastPeriodDate,
    DateTime? endDate,
    DueDate? dueDate,
    String? type,
    String? deliveryType,
    ValueGetter<String?>? notes,
    List<Fetus>? fetuses,
    bool? iKnowDueDate,
    bool? isUpdated,
    bool? isAdded,
    bool? isCompleted,
  }) {
    return PregnancyState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isActive: isActive ?? this.isActive,
      pregnancyId: pregnancyId ?? this.pregnancyId,
      birthGiven: birthGiven ?? this.birthGiven,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      endDate: endDate ?? this.endDate,
      dueDate: dueDate ?? this.dueDate,
      type: type ?? this.type,
      deliveryType: deliveryType ?? this.deliveryType,
      notes: notes != null ? notes() : this.notes,
      fetuses: fetuses ?? this.fetuses,
      iKnowDueDate: iKnowDueDate ?? this.iKnowDueDate,
      isUpdated: isUpdated ?? this.isUpdated,
      isAdded: isAdded ?? this.isAdded,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

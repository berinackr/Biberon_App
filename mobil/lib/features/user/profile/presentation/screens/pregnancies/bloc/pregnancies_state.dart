part of 'pregnancies_bloc.dart';

class PregnanciesState extends Equatable {
  const PregnanciesState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.page = 1,
    this.order = 'asc',
    this.pregnancies = const [],
  });

  final FormzSubmissionStatus? status;
  final String? errorMessage;
  final int page;
  final String order;
  final List<Pregnancy> pregnancies;

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        page,
        order,
        pregnancies,
      ];

  PregnanciesState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    int? page,
    String? order,
    List<Pregnancy>? pregnancies,
  }) {
    return PregnanciesState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      order: order ?? this.order,
      pregnancies: pregnancies ?? this.pregnancies,
    );
  }
}

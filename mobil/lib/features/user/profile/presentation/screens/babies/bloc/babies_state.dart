part of 'babies_bloc.dart';

class BabiesState extends Equatable {
  const BabiesState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.page = 1,
    this.order = 'asc',
    this.babies = const [],
  });

  final FormzSubmissionStatus? status;
  final String? errorMessage;
  final int page;
  final String order;
  final List<Baby> babies;

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        page,
        order,
        babies,
      ];

  BabiesState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    int? page,
    String? order,
    List<Baby>? babies,
  }) {
    return BabiesState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      order: order ?? this.order,
      babies: babies ?? this.babies,
    );
  }
}

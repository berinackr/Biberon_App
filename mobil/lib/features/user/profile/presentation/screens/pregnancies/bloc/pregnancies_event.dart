part of 'pregnancies_bloc.dart';

class PregnanciesEvent extends Equatable {
  const PregnanciesEvent();

  @override
  List<Object> get props => [];
}

class FetchPregnancies extends PregnanciesEvent {
  const FetchPregnancies({
    this.order = 'desc',
    this.page = 1,
  });

  final String order;
  final int page;

  @override
  List<Object> get props => [order, page];
}

class DeletePregnancy extends PregnanciesEvent {
  const DeletePregnancy(this.pregnancyId);
  final int pregnancyId;

  @override
  List<Object> get props => [pregnancyId];
}

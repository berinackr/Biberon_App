part of 'babies_bloc.dart';

sealed class BabiesEvent extends Equatable {
  const BabiesEvent();

  @override
  List<Object> get props => [];
}

class BabiesEventLoadBabies extends BabiesEvent {
  const BabiesEventLoadBabies({this.order = 'asc', this.page = 1});
  final String order;
  final int page;

  @override
  List<Object> get props => [order, page];
}

class BabiesEventDeleteBaby extends BabiesEvent {
  const BabiesEventDeleteBaby(this.babyId);
  final int babyId;
  @override
  List<Object> get props => [babyId];
}

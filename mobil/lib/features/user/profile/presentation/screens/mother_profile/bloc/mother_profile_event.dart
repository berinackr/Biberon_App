part of 'mother_profile_bloc.dart';

sealed class MotherProfileEvent extends Equatable {
  const MotherProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserProfile extends MotherProfileEvent {
  const UpdateUserProfile();
}

class GetUserProfile extends MotherProfileEvent {
  const GetUserProfile();
}

class UpdateUserName extends MotherProfileEvent {
  const UpdateUserName(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class UpdateUserBio extends MotherProfileEvent {
  const UpdateUserBio(this.bio);

  final String bio;

  @override
  List<Object> get props => [bio];
}

class UpdateUserDateOfBirth extends MotherProfileEvent {
  const UpdateUserDateOfBirth(this.dateOfBirth);

  final DateTime dateOfBirth;

  @override
  List<Object> get props => [dateOfBirth];
}

class DeleteUserDateOfBirth extends MotherProfileEvent {
  const DeleteUserDateOfBirth();

  @override
  List<Object> get props => [];
}

class UpdateUserCity extends MotherProfileEvent {
  const UpdateUserCity(this.city);

  final int city;

  @override
  List<Object> get props => [city];
}

class DeleteUserCity extends MotherProfileEvent {
  const DeleteUserCity();

  @override
  List<Object> get props => [];
}

class ClearNotificationStates extends MotherProfileEvent {
  const ClearNotificationStates();
}

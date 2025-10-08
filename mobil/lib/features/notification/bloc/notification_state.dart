part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState._({
    this.token,
  });

  const NotificationState.initial() : this._();

  const NotificationState.token(String? token) : this._(token: token);

  final String? token;
  @override
  List<Object?> get props => [token];
}

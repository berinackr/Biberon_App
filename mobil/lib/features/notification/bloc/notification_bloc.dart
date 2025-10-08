import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/notification/notification.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({
    required Talker logger,
    required NotificationRepository notificationRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _notificationRepository = notificationRepository,
        _logger = logger,
        _authenticationRepository = authenticationRepository,
        super(const NotificationState.initial()) {
    on<NotificationInit>(_onNotificationInit);
  }

  final Talker _logger;
  final NotificationRepository _notificationRepository;
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<void> close() {
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<void> _onNotificationInit(
    NotificationInit event,
    Emitter<NotificationState> emit,
  ) async {
    final token = await _notificationRepository.token;
    if (token == null) {
      return;
    }
    await _authenticationRepository.updateFCMToken(token: token);
    emit(NotificationState.token(token));
    await emit.forEach<String?>(
      _notificationRepository.tokenStream,
      onData: (token) {
        if (token == null) {
          return state;
        }
        _logger.info('Token: $token');
        if (token == state.token) {
          return state;
        }
        _authenticationRepository.updateFCMToken(token: token);
        return NotificationState.token(token);
      },
    );
  }
}

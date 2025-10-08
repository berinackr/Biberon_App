import 'dart:async';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/domain/models/authentication_status.dart';
import 'package:biberon/features/authentication/domain/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required Talker logger,
  })  : _authenticationRepository = authenticationRepository,
        _logger = logger,
        super(
          authenticationRepository.user == null
              ? const AuthenticationState.unknown()
              : AuthenticationState.authenticated(
                  authenticationRepository.user!,
                ),
        ) {
    on<AuthenticationSignoutRequested>(_onAuthenticationSignoutRequested);
    on<AuthenticationSubscriptionRequested>(
      _onAuthenticationSubscriptionRequested,
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final Talker _logger;

  @override
  Future<void> close() {
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.init();
    await emit.forEach<AuthenticationStatus>(
      _authenticationRepository.status,
      onData: (status) {
        switch (status) {
          case AuthenticationStatus.authenticated:
            final user = _authenticationRepository.user;
            _logger.info('User authenticated: $user');
            return user != null
                ? AuthenticationState.authenticated(user)
                : const AuthenticationState.unauthenticated();
          case AuthenticationStatus.unauthenticated:
            return const AuthenticationState.unauthenticated();
          case AuthenticationStatus.authenticatedButNotVerified:
            final user = _authenticationRepository.user;
            _logger.info('User authenticated but not verified: $user');
            return user != null
                ? AuthenticationState.authenticatedButNotVerified(user)
                : const AuthenticationState.unauthenticated();
          case AuthenticationStatus.unknown:
            return const AuthenticationState.unknown();
        }
      },
    );
  }

  void _onAuthenticationSignoutRequested(
    AuthenticationSignoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.signOut();
  }
}

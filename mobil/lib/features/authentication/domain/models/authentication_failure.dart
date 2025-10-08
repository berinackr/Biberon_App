/// {@template authentication_failure}
/// Thrown if during the sign in/up process a failure occurs.
/// {@endtemplate}
class AuthenticationFailure implements Exception {
  /// {@macro authentication_failure}
  const AuthenticationFailure({
    this.message = 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin',
    this.layer = '',
  });

  /// The associated error message.
  final String message;
  final String layer;
}

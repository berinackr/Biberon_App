class AppException implements Exception {
  AppException({
    this.layer = StackTrace.empty,
    this.message = 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin',
  });

  late String message;
  late StackTrace layer;

  @override
  String toString() {
    return message;
  }
}

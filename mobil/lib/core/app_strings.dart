class AppString {
  AppString._();

  // Api Error Messages
  static const String cancelRequest = 'İstek iptal edildi';
  static const String connectionTimeout = 'Bağlantı zaman aşımına uğradı';
  static const String receiveTimeout = 'Bağlantı zaman aşımına uğradı';
  static const String sendTimeout = 'Bağlantı zaman aşımına uğradı';
  static const String socketException =
      'Lütfen internet bağlantınızı kontrol edin';
  static const String unknownError = 'Bir hata oluştu';
  static const String badCertificate = 'Güvenlik sertifikası hatası';

  // Api Response Error Messages
  static const String badRequest = 'Geçersiz istek';
  static const String unauthorized =
      'Bu işlemi yapmadan önce giriş yapmalısınız';
  static const String notFound = 'Aradığınız şeyi bulamadık';
  static const String forbidden = 'Bu işlemi yapmaya yetkiniz yok';
  static const String internalServerError = 'Beklenmeyen bir hata oluştu';
}

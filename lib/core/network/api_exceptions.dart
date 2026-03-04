// ============================================================================
// أخطاء الـ API المخصصة — لمعالجة الأخطاء بشكل موحد
// ============================================================================

/// الخطأ الأساسي لجميع أخطاء الـ API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// خطأ عدم الاتصال بالشبكة
class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'فشل الاتصال بالخادم. تحقق من الشبكة.',
          statusCode: null,
        );
}

/// خطأ انتهاء وقت الاتصال
class TimeoutException extends ApiException {
  TimeoutException()
      : super(
          message: 'انتهى وقت الاتصال. الخادم لا يستجيب.',
          statusCode: 408,
        );
}

/// خطأ عدم المصادقة (401) — التوكن منتهي أو غير صالح
class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'جلستك انتهت. يرجى تسجيل الدخول مجدداً.',
          statusCode: 401,
        );
}

/// خطأ ممنوع (403)
class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(
          message: message ?? 'ليس لديك صلاحية للوصول.',
          statusCode: 403,
        );
}

/// خطأ غير موجود (404)
class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'المحتوى المطلوب غير موجود.',
          statusCode: 404,
        );
}

/// خطأ في البيانات المرسلة (400)
class BadRequestException extends ApiException {
  BadRequestException({String? message, super.data})
      : super(
          message: message ?? 'بيانات غير صالحة.',
          statusCode: 400,
        );
}

/// خطأ في الخادم (500+)
class ServerException extends ApiException {
  ServerException({String? message})
      : super(
          message: message ?? 'خطأ في الخادم. حاول لاحقاً.',
          statusCode: 500,
        );
}

/// خطأ تجاوز الحد المسموح (429)
class TooManyRequestsException extends ApiException {
  TooManyRequestsException({String? message})
      : super(
          message: message ?? 'تجاوزت الحد المسموح. حاول لاحقاً.',
          statusCode: 429,
        );
}

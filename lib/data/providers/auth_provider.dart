// ============================================================================
// مزود المصادقة — إدارة حالة تسجيل الدخول/الخروج/التسجيل مركزياً
// ============================================================================

import 'package:flutter/material.dart';
import '../../core/network/api_service.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/network/token_manager.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _hasCompletedInterests = false;
  String? _errorMessage;

  // بيانات المستخدم الأساسية
  Map<String, dynamic>? _userProfile;

  // ────────────────────────────────────────────
  // Getters
  // ────────────────────────────────────────────
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasCompletedInterests => _hasCompletedInterests;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userProfile => _userProfile;

  /// اسم المستخدم من البروفايل — أو "مستخدم" كقيمة افتراضية
  String get userName =>
      _userProfile?['username'] ?? _userProfile?['full_name'] ?? 'مستخدم';

  /// صورة المستخدم من البروفايل
  String get userImage =>
      _userProfile?['profile_image'] ??
      _userProfile?['avatar'] ??
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=B8860B&color=fff&size=150';

  /// البريد الإلكتروني
  String get userEmail => _userProfile?['email'] ?? '';

  // ────────────────────────────────────────────
  // تهيئة — التحقق من وجود توكن محفوظ
  // ────────────────────────────────────────────

  /// يُستدعى عند بداية التطبيق للتحقق من حالة تسجيل الدخول
  Future<void> checkAuthStatus() async {
    _isLoggedIn = await TokenManager.isLoggedIn();
    _hasCompletedInterests = await TokenManager.hasCompletedInterests();
    if (_isLoggedIn) {
      // محاولة جلب بيانات المستخدم
      try {
        await fetchProfile();
      } catch (_) {
        // إذا فشل جلب البروفايل (التوكن منتهي بالكامل)
        _isLoggedIn = false;
        await TokenManager.clearAll();
      }
    }
    notifyListeners();
  }

  // ────────────────────────────────────────────
  // تسجيل الدخول
  // ────────────────────────────────────────────

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final data = await _api.post(
        ApiConstants.login,
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );

      // حفظ التوكنات
      await TokenManager.saveTokens(
        accessToken: data['access'],
        refreshToken: data['refresh'],
      );

      _isLoggedIn = true;

      // جلب بيانات البروفايل تلقائياً بعد الدخول
      try {
        await fetchProfile();
      } catch (_) {
        // لا مشكلة إذا فشل — البيانات الأساسية محفوظة في التوكن
      }

      // تحميل حالة الاهتمامات
      _hasCompletedInterests = await TokenManager.hasCompletedInterests();

      notifyListeners();
      return true;
    } on BadRequestException catch (e) {
      _setError(e.message);
      return false;
    } on UnauthorizedException {
      _setError('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      return false;
    } on ForbiddenException {
      _setError('عذراً، هذا الحساب محظور أو غير مفعل');
      return false;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل الاتصال: يرجى التحقق من الشبكة.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ────────────────────────────────────────────
  // إنشاء حساب
  // ────────────────────────────────────────────

  Future<bool> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(
        ApiConstants.register,
        body: {
          'username': username,
          'full_name': username,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'confirm_password': confirmPassword,
        },
        requiresAuth: false,
      );
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل الاتصال بالخادم.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ────────────────────────────────────────────
  // التحقق OTP
  // ────────────────────────────────────────────

  Future<bool> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(
        ApiConstants.verifyOtp,
        body: {'email': email, 'otp_code': otpCode},
        requiresAuth: false,
      );
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل الاتصال بالخادم.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ────────────────────────────────────────────
  // إعادة إرسال OTP
  // ────────────────────────────────────────────

  Future<bool> resendOtp({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(
        ApiConstants.resendOtp,
        body: {'email': email},
        requiresAuth: false,
      );
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل الاتصال بالخادم.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ────────────────────────────────────────────
  // طلب إعادة تعيين كلمة المرور
  // ────────────────────────────────────────────

  Future<bool> requestPasswordReset({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(
        ApiConstants.passwordResetRequest,
        body: {'email': email},
        requiresAuth: false,
      );
      return true;
    } on NotFoundException {
      _setError('هذا البريد الإلكتروني غير مسجل لدينا');
      return false;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل الاتصال بالخادم.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ────────────────────────────────────────────
  // تأكيد إعادة تعيين كلمة المرور
  // ────────────────────────────────────────────

  Future<bool> confirmPasswordReset({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(
        ApiConstants.passwordResetConfirm,
        body: {
          'email': email,
          'otp_code': otpCode,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
        requiresAuth: false,
      );
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل الاتصال بالخادم.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ────────────────────────────────────────────
  // تغيير كلمة المرور (وهو مسجل دخول)
  // ────────────────────────────────────────────

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(
        ApiConstants.changePassword,
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل الاتصال بالخادم.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ────────────────────────────────────────────
  // جلب بيانات البروفايل
  // ────────────────────────────────────────────

  Future<void> fetchProfile() async {
    try {
      final data = await _api.get(ApiConstants.profile);
      _userProfile = data is Map<String, dynamic> ? data : null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ────────────────────────────────────────────
  // تسجيل الخروج
  // ────────────────────────────────────────────

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _api.post(ApiConstants.logout, body: {});
    } catch (_) {
      // حتى لو فشل الطلب، نحذف البيانات المحلية
    } finally {
      await TokenManager.clearAll();
      _isLoggedIn = false;
      _userProfile = null;
      _setLoading(false);
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────
  // أدوات داخلية
  // ────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}

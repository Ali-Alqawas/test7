// ============================================================================
// مزود المصادقة — إدارة حالة تسجيل الدخول/الخروج/التسجيل مركزياً
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  // بيانات إضافية
  Map<String, dynamic>? _accountData;
  List<Map<String, dynamic>> _phones = [];
  int _pointsBalance = 0;
  String? _referralCode;
  Map<String, dynamic>? _referralStats;

  // ────────────────────────────────────────────
  // Getters
  // ────────────────────────────────────────────
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasCompletedInterests => _hasCompletedInterests;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userProfile => _userProfile;
  Map<String, dynamic>? get accountData => _accountData;
  List<Map<String, dynamic>> get phones => _phones;
  int get pointsBalance => _pointsBalance;
  String? get referralCode => _referralCode;
  Map<String, dynamic>? get referralStats => _referralStats;

  /// اسم المستخدم من البروفايل — أو "مستخدم" كقيمة افتراضية
  String get userName =>
      _userProfile?['full_name'] ?? _userProfile?['username'] ?? 'مستخدم';

  /// صورة المستخدم من البروفايل
  String get userImage {
    final img = _userProfile?['profile_image'] ?? _userProfile?['avatar'];
    if (img != null && img.toString().isNotEmpty) {
      return ApiConstants.resolveImageUrl(img.toString());
    }
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=B8860B&color=fff&size=150';
  }

  /// البريد الإلكتروني
  String get userEmail =>
      _accountData?['email'] ??
      _userProfile?['account']?['email'] ??
      _userProfile?['email'] ??
      '';

  /// نوع الحساب
  String get accountType =>
      _accountData?['account_type'] ??
      _userProfile?['account']?['account_type'] ??
      'Personal';

  /// رقم الهاتف الأساسي
  String get primaryPhone {
    final primary = _phones.firstWhere(
      (p) => p['is_primary'] == true,
      orElse: () => _phones.isNotEmpty ? _phones.first : {},
    );
    return primary['phone_number'] ?? '';
  }

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

  // ────────────────────────────────────────────
  // تسجيل الدخول عبر Google
  // ────────────────────────────────────────────
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '654606397416-jqq0j7826f64m3gbhhp634beth7pqe4h.apps.googleusercontent.com',
  );

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _clearError();
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false; // المستخدم ألغى
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        _setError('فشل الحصول على رمز Google');
        return false;
      }

      final data = await _api.post(
        ApiConstants.googleAuth,
        body: {'id_token': idToken},
        requiresAuth: false,
      );

      await TokenManager.saveTokens(
        accessToken: data['access'],
        refreshToken: data['refresh'],
      );

      _isLoggedIn = true;
      // احفظ اسم Google كـ fallback مؤقت قبل fetchProfile
      _userProfile = {
        'full_name': googleUser.displayName ?? googleUser.email,
        'username': googleUser.email,
      };
      notifyListeners();
      try { await fetchProfile(); } catch (_) {}
      _hasCompletedInterests = await TokenManager.hasCompletedInterests();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل تسجيل الدخول عبر Google');
      return false;
    } finally {
      _setLoading(false);
    }
  }

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
    required String confirmNewPassword,
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

      // استخراج بيانات الحساب من البروفايل إذا موجودة
      if (_userProfile?['account'] != null) {
        _accountData = Map<String, dynamic>.from(_userProfile!['account']);
        _pointsBalance = _accountData?['points_balance'] ?? 0;
      }

      // استخراج أرقام الهاتف من البروفايل إذا موجودة
      if (_userProfile?['phones'] != null) {
        _phones = List<Map<String, dynamic>>.from(
          (_userProfile!['phones'] as List)
              .map((p) => Map<String, dynamic>.from(p)),
        );
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ────────────────────────────────────────────
  // تحديث الملف الشخصي (PATCH)
  // ────────────────────────────────────────────

  Future<bool> updateProfile({
    String? username,
    String? fullName,
    String? profileImagePath,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        // رفع مع صورة — multipart PATCH
        final fields = <String, String>{};
        if (username != null) fields['username'] = username;
        if (fullName != null) fields['full_name'] = fullName;

        await _api.uploadFileWithMethod(
          ApiConstants.profile,
          method: 'PATCH',
          filePath: profileImagePath,
          fieldName: 'profile_image',
          extraFields: fields,
        );
      } else {
        // تحديث بدون صورة — JSON PATCH
        final body = <String, dynamic>{};
        if (username != null) body['username'] = username;
        if (fullName != null) body['full_name'] = fullName;

        await _api.patch(ApiConstants.profile, body: body);
      }

      // تحديث البيانات المحلية
      await fetchProfile();
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
  // جلب بيانات الحساب
  // ────────────────────────────────────────────

  Future<void> fetchAccount() async {
    try {
      final data = await _api.get(ApiConstants.account);
      if (data is Map<String, dynamic>) {
        _accountData = data;
        _pointsBalance = data['points_balance'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ fetchAccount error: $e');
    }
  }

  // ────────────────────────────────────────────
  // أرقام الهاتف
  // ────────────────────────────────────────────

  Future<void> fetchPhones() async {
    try {
      final data = await _api.get(ApiConstants.phones);
      if (data is Map<String, dynamic> && data['results'] != null) {
        _phones = List<Map<String, dynamic>>.from(
          (data['results'] as List).map((p) => Map<String, dynamic>.from(p)),
        );
      } else if (data is List) {
        _phones = List<Map<String, dynamic>>.from(
          data.map((p) => Map<String, dynamic>.from(p)),
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ fetchPhones error: $e');
    }
  }

  Future<bool> addPhone({
    required String phoneNumber,
    String type = 'Mobile',
    bool isPrimary = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(ApiConstants.phones, body: {
        'phone_number': phoneNumber,
        'type': type,
        'is_primary': isPrimary,
      });
      await fetchPhones();
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
  // النقاط والمكافآت
  // ────────────────────────────────────────────

  Future<Map<String, dynamic>?> fetchPointsBalance() async {
    try {
      final data = await _api.get(ApiConstants.pointsBalance);
      if (data is Map<String, dynamic>) {
        _pointsBalance =
            data['balance'] ?? data['points_balance'] ?? data['points'] ?? 0;
        notifyListeners();
        return data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ fetchPointsBalance error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPointsHistory() async {
    try {
      final data = await _api.get(ApiConstants.pointsHistory);
      if (data is Map<String, dynamic> && data['results'] != null) {
        return List<Map<String, dynamic>>.from(
          (data['results'] as List).map((p) => Map<String, dynamic>.from(p)),
        );
      } else if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((p) => Map<String, dynamic>.from(p)),
        );
      }
      return [];
    } catch (e) {
      debugPrint('❌ fetchPointsHistory error: $e');
      return [];
    }
  }

  // ────────────────────────────────────────────
  // رمز الإحالة
  // ────────────────────────────────────────────

  Future<void> fetchReferralCode() async {
    try {
      final data = await _api.get(ApiConstants.rewardsReferralCode);
      if (data is Map<String, dynamic>) {
        _referralCode = data['referral_code'] ??
            data['code'] ??
            data.values.first?.toString();
      } else if (data is String) {
        _referralCode = data;
      }
      notifyListeners();
    } catch (e) {
      // fallback من auth endpoint
      try {
        final data = await _api.get(ApiConstants.referralCode);
        if (data is Map<String, dynamic>) {
          _referralCode = data['referral_code'] ??
              data['code'] ??
              data.values.first?.toString();
        }
        notifyListeners();
      } catch (_) {
        debugPrint('❌ fetchReferralCode error: $e');
      }
    }
  }

  Future<void> fetchReferralStats() async {
    try {
      final data = await _api.get(ApiConstants.rewardsReferralStats);
      if (data is Map<String, dynamic>) {
        _referralStats = data;
        notifyListeners();
      }
    } catch (e) {
      try {
        final data = await _api.get(ApiConstants.referralStats);
        if (data is Map<String, dynamic>) {
          _referralStats = data;
          notifyListeners();
        }
      } catch (_) {
        debugPrint('❌ fetchReferralStats error: $e');
      }
    }
  }

  // ────────────────────────────────────────────
  // السحوبات
  // ────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> fetchDraws() async {
    try {
      final data = await _api.get(ApiConstants.draws);
      if (data is Map<String, dynamic> && data['results'] != null) {
        return List<Map<String, dynamic>>.from(
          (data['results'] as List).map((d) => Map<String, dynamic>.from(d)),
        );
      } else if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((d) => Map<String, dynamic>.from(d)),
        );
      }
      return [];
    } catch (e) {
      debugPrint('❌ fetchDraws error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchCurrentDraw() async {
    try {
      final data = await _api.get(ApiConstants.currentDraw);
      if (data is Map<String, dynamic>) return data;
      return null;
    } catch (e) {
      debugPrint('❌ fetchCurrentDraw error: $e');
      return null;
    }
  }

  Future<bool> enterDraw(String drawId) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(ApiConstants.enterDraw(drawId), body: {});
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
  // تذاكر الدعم الفني
  // ────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> fetchTickets() async {
    try {
      final data = await _api.get(ApiConstants.tickets);
      if (data is Map<String, dynamic> && data['results'] != null) {
        return List<Map<String, dynamic>>.from(
          (data['results'] as List).map((t) => Map<String, dynamic>.from(t)),
        );
      } else if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((t) => Map<String, dynamic>.from(t)),
        );
      }
      return [];
    } catch (e) {
      debugPrint('❌ fetchTickets error: $e');
      return [];
    }
  }

  Future<bool> createTicket({
    required String description,
    required String issueType,
    String? imagePath,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        // مع صورة — multipart POST
        await _api.uploadFile(
          ApiConstants.tickets,
          filePath: imagePath,
          fieldName: 'image_url',
          extraFields: {
            'description': description,
            'issue_type': issueType,
            'status': 'OPEN',
          },
        );
      } else {
        // بدون صورة — JSON POST
        await _api.post(ApiConstants.tickets, body: {
          'description': description,
          'issue_type': issueType,
          'status': 'OPEN',
        });
      }
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

  Future<bool> replyTicket(String ticketId, String message) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(
        ApiConstants.replyTicket(ticketId),
        body: {'message': message},
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

  Future<bool> closeTicket(String ticketId) async {
    _setLoading(true);
    _clearError();

    try {
      await _api.post(ApiConstants.closeTicket(ticketId), body: {});
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
  // 💬 التعليقات
  // ────────────────────────────────────────────

  /// جلب تعليقات منتج معين
  Future<List<Map<String, dynamic>>> fetchProductComments(
      String productId) async {
    try {
      final data = await _api.get(
        ApiConstants.productComments(productId),
      );
      final List raw =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);
      return raw.cast<Map<String, dynamic>>();
    } on ApiException catch (e) {
      debugPrint('خطأ جلب التعليقات: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('خطأ جلب التعليقات: $e');
      return [];
    }
  }

  /// إضافة تعليق جديد — POST /social/products/{id}/comments/
  Future<Map<String, dynamic>?> addComment({
    required int productId,
    required String text,
  }) async {
    try {
      final body = {
        'text': text,
      };
      debugPrint(
          '📤 addComment → POST ${ApiConstants.productComments(productId.toString())} body: $body');
      final data = await _api.post(
        ApiConstants.productComments(productId.toString()),
        body: body,
      );
      return data is Map<String, dynamic> ? data : null;
    } on ApiException catch (e) {
      _setError(e.message);
      return null;
    } catch (e) {
      _setError('فشل إرسال التعليق.');
      return null;
    }
  }

  /// حذف تعليق (204 No Content)
  Future<bool> deleteComment(int commentId) async {
    try {
      await _api.delete(ApiConstants.deleteComment(commentId));
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('فشل حذف التعليق.');
      return false;
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
      _accountData = null;
      _phones = [];
      _pointsBalance = 0;
      _referralCode = null;
      _referralStats = null;
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

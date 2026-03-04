// ============================================================================
// إدارة التوكن — حفظ واسترجاع وحذف JWT tokens مركزياً
// ============================================================================

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _interestsCompletedKey = 'interests_completed';

  // ────────────────────────────────────────────
  // حفظ التوكنات
  // ────────────────────────────────────────────

  /// حفظ access و refresh tokens بعد تسجيل الدخول
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    debugPrint('✅ TokenManager: تم حفظ التوكنات بنجاح');
  }

  /// حفظ بيانات المستخدم الأساسية
  static Future<void> saveUserInfo({
    String? userId,
    String? username,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) await prefs.setString(_userIdKey, userId);
    if (username != null) await prefs.setString(_usernameKey, username);
    if (email != null) await prefs.setString(_emailKey, email);
  }

  // ────────────────────────────────────────────
  // استرجاع التوكنات
  // ────────────────────────────────────────────

  /// الحصول على Access Token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// الحصول على Refresh Token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // ────────────────────────────────────────────
  // استرجاع بيانات المستخدم
  // ────────────────────────────────────────────

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // ────────────────────────────────────────────
  // علامة إكمال الاهتمامات
  // ────────────────────────────────────────────

  /// هل أكمل المستخدم اختيار اهتماماته؟
  static Future<bool> hasCompletedInterests() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_interestsCompletedKey) ?? false;
  }

  /// تعليم أن المستخدم أكمل اختيار الاهتمامات
  static Future<void> setInterestsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_interestsCompletedKey, true);
  }

  // ────────────────────────────────────────────
  // التحقق من حالة التسجيل
  // ────────────────────────────────────────────

  /// هل المستخدم مسجل دخول؟
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ────────────────────────────────────────────
  // تحديث التوكن
  // ────────────────────────────────────────────

  /// تحديث Access Token فقط (بعد التجديد)
  static Future<void> updateAccessToken(String newAccessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, newAccessToken);
    debugPrint('🔄 TokenManager: تم تجديد Access Token');
  }

  // ────────────────────────────────────────────
  // حذف البيانات (تسجيل الخروج)
  // ────────────────────────────────────────────

  /// مسح جميع بيانات المستخدم والتوكنات
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_interestsCompletedKey);
    debugPrint('🚪 TokenManager: تم مسح جميع البيانات (تسجيل خروج)');
  }
}

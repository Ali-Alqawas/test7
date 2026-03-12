// ============================================================================
// خدمة API الموحدة — HTTP Client مركزي مع تجديد تلقائي للتوكن
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'api_exceptions.dart';
import 'token_manager.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 15);

  // علم لمنع التجديد المتكرر
  bool _isRefreshing = false;

  // ──────────────────────────────────────────────────────────────
  // الطلبات الأساسية
  // ──────────────────────────────────────────────────────────────

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    return _executeWithRetry(() async {
      final response =
          await _client.get(uri, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    }, requiresAuth: requiresAuth);
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    return _executeWithRetry(() async {
      final response = await _client
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    }, requiresAuth: requiresAuth);
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    return _executeWithRetry(() async {
      final response = await _client
          .put(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    }, requiresAuth: requiresAuth);
  }

  /// PATCH request
  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    return _executeWithRetry(() async {
      final response = await _client
          .patch(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    }, requiresAuth: requiresAuth);
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    return _executeWithRetry(() async {
      final response =
          await _client.delete(uri, headers: headers).timeout(_timeout);
      return _handleResponse(response);
    }, requiresAuth: requiresAuth);
  }

  /// Multipart POST (لرفع الملفات)
  Future<dynamic> uploadFile(
    String endpoint, {
    required String filePath,
    String fieldName = 'file',
    Map<String, String>? extraFields,
    bool requiresAuth = true,
  }) async {
    return uploadFileWithMethod(
      endpoint,
      method: 'POST',
      filePath: filePath,
      fieldName: fieldName,
      extraFields: extraFields,
      requiresAuth: requiresAuth,
    );
  }

  /// Multipart request بأي HTTP method (POST, PATCH, PUT)
  Future<dynamic> uploadFileWithMethod(
    String endpoint, {
    required String filePath,
    String method = 'POST',
    String fieldName = 'file',
    Map<String, String>? extraFields,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final token = requiresAuth ? await TokenManager.getAccessToken() : null;

    final request = http.MultipartRequest(method, uri);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    if (extraFields != null) {
      request.fields.addAll(extraFields);
    }

    final streamedResponse = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────────────────────
  // بناء الـ URI والـ Headers
  // ──────────────────────────────────────────────────────────────

  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final url = '${ApiConstants.baseUrl}$endpoint';
    final uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  Future<Map<String, String>> _buildHeaders({
    required bool requiresAuth,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await TokenManager.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ──────────────────────────────────────────────────────────────
  // معالجة الاستجابة
  // ──────────────────────────────────────────────────────────────

  dynamic _handleResponse(http.Response response) {
    _logResponse(response);

    // حماية من ردود HTML
    if (response.body.isNotEmpty && response.body.trimLeft().startsWith('<')) {
      throw ServerException(
        message: 'خطأ في السيرفر: تأكد من تشغيل الخادم.',
      );
    }

    // استجابة بدون محتوى (مثل 204 No Content)
    if (response.statusCode == 204 || response.body.isEmpty) {
      return null;
    }

    final dynamic data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    // استخراج رسالة الخطأ من الاستجابة
    String errorMessage = _extractErrorMessage(data);

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(message: errorMessage, data: data);
      case 401:
        throw UnauthorizedException(message: errorMessage);
      case 403:
        throw ForbiddenException(message: errorMessage);
      case 404:
        throw NotFoundException(message: errorMessage);
      case 429:
        throw TooManyRequestsException(message: errorMessage);
      default:
        if (response.statusCode >= 500) {
          throw ServerException(message: errorMessage);
        }
        throw ApiException(
          message: errorMessage,
          statusCode: response.statusCode,
          data: data,
        );
    }
  }

  /// استخراج رسالة الخطأ من response data
  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // محاولة استخراج 'detail' أولاً (الشائع في Django REST)
      if (data.containsKey('detail')) return data['detail'].toString();
      if (data.containsKey('message')) return data['message'].toString();
      if (data.containsKey('error')) return data['error'].toString();

      // إذا كانت الأخطاء في حقول محددة
      final errors = <String>[];
      data.forEach((key, value) {
        if (value is List) {
          errors.add('$key: ${value.join(', ')}');
        } else {
          errors.add('$key: $value');
        }
      });
      if (errors.isNotEmpty) return errors.join('\n');
    }
    return 'حدث خطأ غير متوقع';
  }

  // ──────────────────────────────────────────────────────────────
  // تجديد التوكن التلقائي + إعادة المحاولة
  // ──────────────────────────────────────────────────────────────

  Future<dynamic> _executeWithRetry(
    Future<dynamic> Function() request, {
    required bool requiresAuth,
  }) async {
    try {
      return await request();
    } on UnauthorizedException {
      // محاولة تجديد التوكن عند 401
      if (!requiresAuth || _isRefreshing) rethrow;

      final refreshed = await _refreshToken();
      if (refreshed) {
        // إعادة الطلب بالتوكن الجديد
        return await request();
      } else {
        // فشل التجديد — التوكن منتهي بالكامل
        await TokenManager.clearAll();
        rethrow;
      }
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(message: 'فشل الاتصال: $e');
    }
  }

  /// تجديد Access Token باستخدام Refresh Token
  Future<bool> _refreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refreshToken = await TokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final uri = _buildUri(ApiConstants.tokenRefresh);
      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refresh': refreshToken}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access'] as String;
        await TokenManager.updateAccessToken(newAccessToken);
        debugPrint('🔄 ApiService: تم تجديد التوكن بنجاح');
        return true;
      } else {
        debugPrint('❌ ApiService: فشل تجديد التوكن (${response.statusCode})');
        return false;
      }
    } catch (e) {
      debugPrint('❌ ApiService: خطأ أثناء تجديد التوكن: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Logging (فقط في وضع التطوير)
  // ──────────────────────────────────────────────────────────────

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      debugPrint('📡 ${response.request?.method} ${response.request?.url}');
      debugPrint('   ↳ Status: ${response.statusCode}');
      if (response.statusCode >= 400) {
        debugPrint(
            '   ↳ Body: ${response.body.substring(0, response.body.length.clamp(0, 200))}');
      }
    }
  }
}

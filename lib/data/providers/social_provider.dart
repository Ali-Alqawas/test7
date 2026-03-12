import 'package:flutter/material.dart';
import '../../core/network/api_service.dart';

// ============================================================================
// SocialProvider — إدارة مركزية للإعجابات والمفضلة
// يدعم نوعين:
//   1. المنتجات الفردية: /social/likes/ و /social/favorites/
//   2. المجموعات (الباقات/البروشورات): /social/group-likes/ و /social/group-favorites/
// ============================================================================
class SocialProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  // ── المنتجات الفردية: productId → recordId ──
  final Map<String, int> _favoriteRecords = {};
  final Map<String, int> _likeRecords = {};

  // ── المجموعات: groupId → recordId ──
  final Map<String, int> _groupFavoriteRecords = {};
  final Map<String, int> _groupLikeRecords = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ── فحص الحالة ──
  bool isFavorited(String productId) => _favoriteRecords.containsKey(productId);
  bool isLiked(String productId) => _likeRecords.containsKey(productId);

  bool isGroupFavorited(String groupId) =>
      _groupFavoriteRecords.containsKey(groupId);
  bool isGroupLiked(String groupId) => _groupLikeRecords.containsKey(groupId);

  int get favoritesCount => _favoriteRecords.length;

  // ──────────────────────────────────────────────────────────────
  // جلب البيانات الأولية (يُستدعى عند فتح التطبيق)
  // ──────────────────────────────────────────────────────────────
  Future<void> fetchUserSocialData() async {
    _isLoading = true;
    notifyListeners();

    // 1. المفضلة (منتجات)
    await _fetchRecords('/social/favorites/', _favoriteRecords, 'product');
    // 2. اللايكات (منتجات)
    await _fetchRecords('/social/likes/', _likeRecords, 'product');
    // 3. المفضلة (مجموعات)
    await _fetchRecords(
        '/social/group-favorites/', _groupFavoriteRecords, 'product_group');
    // 4. اللايكات (مجموعات)
    await _fetchRecords(
        '/social/group-likes/', _groupLikeRecords, 'product_group');

    _isLoading = false;
    notifyListeners();
  }

  /// جلب سجلات من endpoint معين وتعبئة الـ Map
  Future<void> _fetchRecords(
      String endpoint, Map<String, int> targetMap, String idField) async {
    try {
      final response = await _api.get(endpoint);
      if (response != null) {
        targetMap.clear();
        final List results = response is Map
            ? (response['results'] ?? [])
            : (response is List ? response : []);
        for (var item in results) {
          final itemId = item[idField]?.toString();
          final recordId = item['id'];
          if (itemId != null && itemId.isNotEmpty && recordId is int) {
            targetMap[itemId] = recordId;
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ خطأ في جلب $endpoint: $e');
    }
  }

  // ──────────────────────────────────────────────────────────────
  // تبديل المفضلة (منتج فردي)
  // ──────────────────────────────────────────────────────────────
  Future<bool> toggleFavorite(String productId) async {
    return _toggle(
      id: productId,
      records: _favoriteRecords,
      addEndpoint: '/social/favorites/',
      bodyKey: 'product',
      label: 'المفضلة',
    );
  }

  // ──────────────────────────────────────────────────────────────
  // تبديل الإعجاب (منتج فردي)
  // ──────────────────────────────────────────────────────────────
  Future<bool> toggleLike(String productId) async {
    return _toggle(
      id: productId,
      records: _likeRecords,
      addEndpoint: '/social/likes/',
      bodyKey: 'product',
      label: 'الإعجاب',
    );
  }

  // ──────────────────────────────────────────────────────────────
  // تبديل المفضلة (مجموعة / باقة)
  // ──────────────────────────────────────────────────────────────
  Future<bool> toggleGroupFavorite(String groupId) async {
    return _toggle(
      id: groupId,
      records: _groupFavoriteRecords,
      addEndpoint: '/social/group-favorites/',
      bodyKey: 'product_group',
      label: 'مفضلة المجموعة',
    );
  }

  // ──────────────────────────────────────────────────────────────
  // تبديل الإعجاب (مجموعة / باقة)
  // ──────────────────────────────────────────────────────────────
  Future<bool> toggleGroupLike(String groupId) async {
    return _toggle(
      id: groupId,
      records: _groupLikeRecords,
      addEndpoint: '/social/group-likes/',
      bodyKey: 'product_group',
      label: 'إعجاب المجموعة',
    );
  }

  // ──────────────────────────────────────────────────────────────
  // المنطق الموحد للتبديل (يخدم كل الأنواع)
  // ──────────────────────────────────────────────────────────────
  Future<bool> _toggle({
    required String id,
    required Map<String, int> records,
    required String addEndpoint,
    required String bodyKey,
    required String label,
  }) async {
    if (id.isEmpty) return false;

    final bool wasActive = records.containsKey(id);
    final int? oldRecordId = records[id];

    // Optimistic UI
    if (wasActive) {
      records.remove(id);
    } else {
      records[id] = -1; // مؤقت
    }
    notifyListeners();

    try {
      if (wasActive && oldRecordId != null && oldRecordId != -1) {
        await _api.delete('$addEndpoint$oldRecordId/');
      } else if (!wasActive) {
        try {
          final response = await _api.post(
            addEndpoint,
            body: {bodyKey: int.parse(id)},
          );
          if (response != null && response['id'] != null) {
            records[id] = response['id'];
            notifyListeners();
          }
        } catch (e) {
          // إذا كان الخطأ duplicate key — يعني موجود فعلاً، نحذفه
          if (e.toString().contains('duplicate key') ||
              e.toString().contains('already exists') ||
              e.toString().contains('unique constraint')) {
            debugPrint('⚠️ $label موجود فعلاً — جاري الحذف...');
            // جلب السجلات الموجودة للعثور على record_id
            try {
              final existing = await _api.get(addEndpoint);
              final List items = existing is Map
                  ? (existing['results'] ?? [])
                  : (existing is List ? existing : []);
              for (var item in items) {
                final itemId = item[bodyKey]?.toString() ??
                    item['${bodyKey}_id']?.toString() ??
                    '';
                if (itemId == id) {
                  final recordId = item['id'];
                  if (recordId != null) {
                    await _api.delete('$addEndpoint$recordId/');
                    records.remove(id);
                    notifyListeners();
                    return true;
                  }
                }
              }
            } catch (_) {}
            // التراجع إذا فشل الحذف
            records.remove(id);
            notifyListeners();
            return false;
          } else {
            rethrow;
          }
        }
      }
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في تبديل $label: $e');
      // التراجع
      if (wasActive && oldRecordId != null) {
        records[id] = oldRecordId;
      } else {
        records.remove(id);
      }
      notifyListeners();
      return false;
    }
  }

  // حذف من المفضلة محلياً (لشاشة المفضلة عند السحب)
  void removeFavoriteLocally(String productId) {
    _favoriteRecords.remove(productId);
    notifyListeners();
  }

  // مسح كل البيانات (عند تسجيل الخروج)
  void clear() {
    _favoriteRecords.clear();
    _likeRecords.clear();
    _groupFavoriteRecords.clear();
    _groupLikeRecords.clear();
    notifyListeners();
  }
}

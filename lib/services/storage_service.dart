import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Thin wrapper around shared_preferences so the app keeps working
/// (with fresh seeded data) even if persistence ever fails.
class StorageService {
  static const _kOnboarded = 'cribeit_onboarded';
  static const _kArtisan = 'cribeit_artisan';
  static const _kProducts = 'cribeit_products';
  static const _kLanguage = 'cribeit_language';

  Future<bool> isOnboarded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kOnboarded) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> setOnboarded(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOnboarded, value);
    } catch (_) {}
  }

  Future<void> saveLanguage(AppLanguage lang) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguage, lang.code);
    } catch (_) {}
  }

  Future<AppLanguage?> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_kLanguage);
      if (code == null) return null;
      return AppLanguageX.fromCode(code);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveArtisan(Artisan artisan) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kArtisan, jsonEncode(artisan.toJson()));
    } catch (_) {}
  }

  Future<Artisan?> loadArtisan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kArtisan);
      if (raw == null) return null;
      return Artisan.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProducts(List<Product> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = products.map((p) => p.toJson()).toList();
      await prefs.setString(_kProducts, jsonEncode(list));
    } catch (_) {}
  }

  Future<List<Product>?> loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kProducts);
      if (raw == null) return null;
      final list = jsonDecode(raw) as List;
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }
}

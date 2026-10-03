import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Typed wrapper over SharedPreferences. Every persisted key lives here.
class LocalStorage {
  LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorage> create() async =>
      LocalStorage(await SharedPreferences.getInstance());

  static const authToken = 'auth_token';
  static const authUser = 'auth_user';
  static const cart = 'cart_items';
  static const wishlist = 'wishlist_items';
  static const garage = 'garage_vehicles';
  static const selectedVehicle = 'garage_selected';
  static const addresses = 'addresses';
  static const orders = 'orders';
  static const recentSearches = 'recent_searches';
  static const themeMode = 'theme_mode';

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) => _prefs.setString(key, value);
  Future<void> remove(String key) => _prefs.remove(key);

  Object? readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> writeJson(String key, Object value) =>
      _prefs.setString(key, jsonEncode(value));

  List<T> readList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final data = readJson(key);
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  List<String> getStringList(String key) => _prefs.getStringList(key) ?? [];
  Future<void> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
}

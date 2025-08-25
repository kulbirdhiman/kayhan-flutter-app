import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  static const _tokenKey = 'auth_token';

  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  /// Load token on startup
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _isLoggedIn = _token != null;
    notifyListeners();
  }

  /// Login and save token
  Future<void> login(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _token = token;
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Logout and clear token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}

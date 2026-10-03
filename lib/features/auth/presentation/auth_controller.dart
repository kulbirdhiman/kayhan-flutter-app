import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/storage/local_storage.dart';
import '../data/auth_repository.dart';
import '../data/models/user.dart';

/// Session state. Also used as the router's refresh listenable.
class AuthController extends ChangeNotifier {
  AuthController(this._storage) {
    _token = _storage.getString(LocalStorage.authToken);
    final cached = _storage.readJson(LocalStorage.authUser);
    if (cached is Map<String, dynamic>) _user = User.fromJson(cached);
  }

  final LocalStorage _storage;
  late AuthRepository _repo;

  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;
  bool get isLoggedIn => _token != null;

  /// Wired after construction because the API client reads [token].
  void attach(AuthRepository repo) => _repo = repo;

  Future<void> signIn(String email, String password) async {
    final session = await _repo.signIn(email: email, password: password);
    await _start(session);
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final session = await _repo.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
    );
    await _start(session);
  }

  /// Refreshes the profile; signs out if the token is no longer valid.
  Future<void> refreshProfile() async {
    if (!isLoggedIn) return;
    try {
      final user = await _repo.profile();
      if (user != null) await _setUser(user);
    } on ApiException catch (e) {
      if (e.isUnauthorized) await signOut();
    } catch (_) {
      // Keep the cached profile when offline.
    }
  }

  Future<void> signOut() async {
    _token = null;
    _user = null;
    await _storage.remove(LocalStorage.authToken);
    await _storage.remove(LocalStorage.authUser);
    notifyListeners();
  }

  Future<void> _start(AuthSession session) async {
    _token = session.token;
    await _storage.setString(LocalStorage.authToken, session.token);
    if (session.user != null) {
      await _setUser(session.user!);
    } else {
      notifyListeners();
      await refreshProfile();
    }
  }

  Future<void> _setUser(User user) async {
    _user = user;
    await _storage.writeJson(LocalStorage.authUser, user.toJson());
    notifyListeners();
  }
}

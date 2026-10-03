import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import 'models/user.dart';

class AuthSession {
  const AuthSession({required this.token, this.user});

  final String token;
  final User? user;
}

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<AuthSession> signIn({required String email, required String password}) async {
    final data = await _api.post(ApiEndpoints.signIn, body: {'email': email, 'password': password});
    return _session(data);
  }

  Future<AuthSession> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final data = await _api.post(ApiEndpoints.signUp, body: {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': password,
    });
    return _session(data);
  }

  Future<User?> profile() async {
    final data = await _api.get(ApiEndpoints.myProfile);
    final user = data is Map ? data['user'] : null;
    return user is Map ? User.fromJson(Map<String, dynamic>.from(user)) : null;
  }

  // Password recovery: email → OTP → new password.
  Future<void> sendResetCode(String email) => _api.post(ApiEndpoints.sendOtp, body: {'email': email});

  Future<void> verifyResetCode({required String email, required String otp}) =>
      _api.post(ApiEndpoints.verifyOtp, body: {'email': email, 'otp': otp});

  Future<void> setNewPassword({required String email, required String otp, required String password}) =>
      _api.post(ApiEndpoints.setPassword, body: {'email': email, 'otp': otp, 'password': password});

  Future<void> changePassword({required String current, required String next}) =>
      _api.post(ApiEndpoints.changePassword, body: {'old_password': current, 'new_password': next});

  AuthSession _session(dynamic data) {
    final token = data is Map ? data['token']?.toString() : null;
    if (token == null || token.isEmpty) {
      throw const ApiException('Sign-in failed. Please try again.');
    }
    final user = data['user'];
    return AuthSession(
      token: token,
      user: user is Map ? User.fromJson(Map<String, dynamic>.from(user)) : null,
    );
  }
}

import 'package:dio/dio.dart';
import 'api_client.dart';

class AuthService {
  // Login
  static Future<Response> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        "/v1/auth/sign_in",
        data: {"email": email, "password": password},
      );
      return response;
    } catch (e) {
      rethrow; // pass error back
    }
  }

  // Register
  static Future<Response> register(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post("/auth/register", data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

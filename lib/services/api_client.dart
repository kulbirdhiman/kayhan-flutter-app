import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.kayhanaudio.com.au", 
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  // Example: Add interceptors for logging or token refresh
  static void init() {
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}

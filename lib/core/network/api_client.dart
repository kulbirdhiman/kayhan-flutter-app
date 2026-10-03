import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'api_exception.dart';

/// Thin wrapper around Dio that unwraps the backend's
/// `{ success, message, data }` envelope and normalises errors.
class ApiClient {
  ApiClient({required String? Function() tokenProvider})
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenProvider();
          // The backend expects the raw token, without a "Bearer" prefix.
          if (token != null) options.headers['Authorization'] = token;
          handler.next(options);
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(responseBody: false));
    }
  }

  final Dio _dio;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? body}) =>
      _send(() => _dio.post(path, data: body));

  /// Returns the `data` field of the response envelope.
  Future<dynamic> _send(Future<Response> Function() request) async {
    try {
      final response = await request();
      final body = response.data;
      if (body is Map && body['success'] == false) {
        throw ApiException(
          (body['message'] ?? body['error'] ?? 'Request failed').toString(),
          statusCode: response.statusCode,
        );
      }
      return body is Map && body.containsKey('data') ? body['data'] : body;
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

import 'package:dio/dio.dart';

/// A user-presentable error raised by the data layer.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  factory ApiException.from(Object error) {
    if (error is ApiException) return error;
    if (error is DioException) {
      final data = error.response?.data;
      final serverMessage = data is Map
          ? (data['message'] ?? data['error'])?.toString()
          : null;
      final status = error.response?.statusCode;

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const ApiException('The server took too long to respond.');
        case DioExceptionType.connectionError:
          return const ApiException('No internet connection.');
        default:
          return ApiException(
            serverMessage ?? 'Something went wrong. Please try again.',
            statusCode: status,
          );
      }
    }
    return const ApiException('Something went wrong. Please try again.');
  }

  @override
  String toString() => message;
}

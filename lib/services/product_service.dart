import 'api_client.dart';
import 'package:dio/dio.dart';

class ProductService {
  /// Fetch product list with pagination + search
  static Future<Response> fetchProducts({
    required int page,
    required int limit,
    String? search,
  }) async {
    try {
      final response = await ApiClient.dio.get(
        "/v1/product/list/shop",
        queryParameters: {
          "page": page,
          "limit": limit,
          if (search != null && search.isNotEmpty) "search": search,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> fetchProductByID(String productId) async {
    try {
      final response = await ApiClient.dio.get(
        "/v1/product/list/$productId", 
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

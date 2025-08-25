import 'api_client.dart';
import 'package:dio/dio.dart';

class HomeService {
  static Future<Response> highlights() async {
    try {
      final response = await ApiClient.dio.get("/v1/home/weekly_highlights");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> recomended() async {
    try {
      final response = await ApiClient.dio.get("/v1/home/recomened_product");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> hotdeal() async {
    try {
      final response = await ApiClient.dio.get("/v1/home/hot_deals");
      return response;
    } catch (e) {
      rethrow;
    }
  }
   static Future<Response> combodeals() async {
    try {
      final response = await ApiClient.dio.get("/v1/combodeals");
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

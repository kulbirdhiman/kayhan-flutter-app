import 'dart:convert';

import '../../../../core/config/app_config.dart';
import '../../../../core/utils/formatters.dart';

/// Bundle of a head unit plus add-ons. Its slug opens as a normal product.
class ComboDeal {
  const ComboDeal({
    required this.id,
    required this.slug,
    required this.name,
    required this.addOnName,
    required this.price,
    this.dealPrice,
    this.image,
    this.addOnImages = const [],
  });

  final int id;
  final String slug;
  final String name;
  final String addOnName;
  final double price;
  final double? dealPrice;
  final String? image;
  final List<String> addOnImages;

  double get finalPrice => dealPrice ?? price;

  factory ComboDeal.fromJson(Map<String, dynamic> json) {
    final price = Formatters.parseAmount(json['price']);
    final deal = Formatters.parseAmount(json['discount_price']);
    final images = _decodeImages(json['image']);
    return ComboDeal(
      id: (json['id'] as num).toInt(),
      slug: (json['slug'] ?? '').toString(),
      name: (json['name'] ?? '').toString().trim(),
      addOnName: (json['subproduct_name'] ?? '').toString().trim(),
      price: price,
      dealPrice: deal > 0 && deal < price ? deal : null,
      image: images.isEmpty ? null : images.first,
      addOnImages: _decodeImages(json['subproduct_images']),
    );
  }

  /// Images arrive as a JSON-encoded string: `"[{\"image\":\"uploads/..\"}]"`.
  static List<String> _decodeImages(Object? raw) {
    try {
      final list = raw is String ? jsonDecode(raw) : raw;
      if (list is! List) return const [];
      return list
          .whereType<Map>()
          .map((e) => e['image']?.toString())
          .whereType<String>()
          .map(AppConfig.imageUrl)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}

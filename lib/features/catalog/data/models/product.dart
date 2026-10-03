import '../../../../core/config/app_config.dart';
import '../../../../core/utils/formatters.dart';

class Product {
  const Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.images,
    required this.regularPrice,
    this.salePrice,
    this.sku = '',
    this.headline,
    this.summary,
    this.descriptionHtml,
    this.specificationHtml,
    this.inStock = true,
    this.isPreOrder = false,
    this.yearFrom,
    this.yearTo,
  });

  final int id;
  final String slug;
  final String name;
  final String sku;

  /// Marketing title from the CMS (`title`), shorter than [name].
  final String? headline;

  /// Plain-text SEO summary.
  final String? summary;
  final String? descriptionHtml;
  final String? specificationHtml;

  /// Full CDN URLs.
  final List<String> images;
  final double regularPrice;
  final double? salePrice;
  final bool inStock;
  final bool isPreOrder;
  final int? yearFrom;
  final int? yearTo;

  double get price => salePrice ?? regularPrice;
  bool get onSale => salePrice != null;
  String? get thumbnail => images.isEmpty ? null : images.first;

  int get discountPercent =>
      onSale && regularPrice > 0 ? (((regularPrice - salePrice!) / regularPrice) * 100).round() : 0;

  /// Whether the product's fitment range covers [year]. Unknown ranges return null.
  bool? fitsYear(int year) {
    if (yearFrom == null || yearTo == null || yearFrom == 0) return null;
    return year >= yearFrom! && year <= yearTo!;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final regular = Formatters.parseAmount(json['regular_price'] ?? json['price']);
    final discount = Formatters.parseAmount(json['discount_price']);
    final rawImages = json['images'];

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: (json['slug'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Product').toString().trim(),
      headline: json['title']?.toString(),
      sku: (json['sku'] ?? '').toString(),
      summary: json['seo_description']?.toString().trim(),
      descriptionHtml: json['description']?.toString(),
      specificationHtml: json['specification']?.toString(),
      images: rawImages is List
          ? rawImages
              .whereType<Map>()
              .map((e) => e['image']?.toString())
              .whereType<String>()
              .where((p) => p.isNotEmpty)
              .map(AppConfig.imageUrl)
              .toList()
          : (json['image_urls'] as List?)?.cast<String>() ?? const [],
      regularPrice: regular,
      salePrice: discount > 0 && discount < regular ? discount : null,
      inStock: json['in_stock'] == null || json['in_stock'] == 1 || json['in_stock'] == true,
      isPreOrder: json['is_pre_order'] == true || json['is_pre_order'] == 1,
      yearFrom: (json['from'] as num?)?.toInt(),
      yearTo: (json['to'] as num?)?.toInt(),
    );
  }

  /// Compact form persisted for wishlist entries.
  Map<String, dynamic> toSnapshotJson() => {
        'id': id,
        'slug': slug,
        'name': name,
        'sku': sku,
        'image_urls': images.take(1).toList(),
        'regular_price': regularPrice,
        'discount_price': salePrice ?? 0,
        'in_stock': inStock ? 1 : 0,
      };
}

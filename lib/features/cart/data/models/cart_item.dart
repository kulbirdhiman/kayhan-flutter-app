import '../../../catalog/data/models/product.dart';

class CartItem {
  const CartItem({
    required this.productId,
    required this.slug,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.compareAtPrice,
    this.image,
    this.sku = '',
  });

  final int productId;
  final String slug;
  final String name;
  final String sku;
  final String? image;
  final double unitPrice;
  final double? compareAtPrice;
  final int quantity;

  double get lineTotal => unitPrice * quantity;
  double get lineSavings =>
      compareAtPrice != null && compareAtPrice! > unitPrice ? (compareAtPrice! - unitPrice) * quantity : 0;

  factory CartItem.fromProduct(Product p, int quantity) => CartItem(
        productId: p.id,
        slug: p.slug,
        name: p.name,
        sku: p.sku,
        image: p.thumbnail,
        unitPrice: p.price,
        compareAtPrice: p.onSale ? p.regularPrice : null,
        quantity: quantity,
      );

  CartItem copyWith({int? quantity}) => CartItem(
        productId: productId,
        slug: slug,
        name: name,
        sku: sku,
        image: image,
        unitPrice: unitPrice,
        compareAtPrice: compareAtPrice,
        quantity: quantity ?? this.quantity,
      );

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as int,
        slug: json['slug'] as String,
        name: json['name'] as String,
        sku: (json['sku'] ?? '') as String,
        image: json['image'] as String?,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
        quantity: json['quantity'] as int,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'slug': slug,
        'name': name,
        'sku': sku,
        'image': image,
        'unitPrice': unitPrice,
        'compareAtPrice': compareAtPrice,
        'quantity': quantity,
      };
}

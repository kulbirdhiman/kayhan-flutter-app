import 'package:flutter_test/flutter_test.dart';
import 'package:kayhan_app/core/utils/formatters.dart';
import 'package:kayhan_app/core/utils/html_utils.dart';
import 'package:kayhan_app/features/catalog/data/models/combo_deal.dart';
import 'package:kayhan_app/features/catalog/data/models/product.dart';

void main() {
  test('parseAmount handles numbers, numeric strings and currency strings', () {
    expect(Formatters.parseAmount(1395), 1395);
    expect(Formatters.parseAmount('920.7'), 920.7);
    expect(Formatters.parseAmount(r'$1676.75'), 1676.75);
    expect(Formatters.parseAmount(null), 0);
  });

  test('Product.fromJson maps API fields and ignores zero discount', () {
    final p = Product.fromJson({
      'id': 2,
      'slug': 'alfa-147',
      'name': 'Car Stereo for ALFA ROMEO 147',
      'regular_price': 1395,
      'discount_price': 0,
      'in_stock': 1,
      'from': 2005,
      'to': 2014,
      'images': [
        {'image': 'uploads/a b.png'},
      ],
    });
    expect(p.price, 1395);
    expect(p.onSale, isFalse);
    expect(p.images.single, endsWith('/uploads/a%20b.png'));
    expect(p.fitsYear(2010), isTrue);
    expect(p.fitsYear(2020), isFalse);
  });

  test('Product sale price and wishlist snapshot round-trip', () {
    final p = Product.fromJson({'id': 1, 'slug': 's', 'name': 'n', 'regular_price': 100, 'discount_price': '80'});
    expect(p.onSale, isTrue);
    expect(p.discountPercent, 20);
    final restored = Product.fromJson(p.toSnapshotJson());
    expect(restored.price, 80);
    expect(restored.regularPrice, 100);
  });

  test('ComboDeal decodes JSON-encoded image strings', () {
    final deal = ComboDeal.fromJson({
      'id': 3,
      'slug': 'combo',
      'name': 'Combo',
      'price': '2053',
      'discount_price': r'$1950.35',
      'image': '[{"image":"uploads/1.png"}]',
      'subproduct_images': '[{"image":"uploads/2.png"},{"image":"uploads/3.png"}]',
    });
    expect(deal.finalPrice, 1950.35);
    expect(deal.addOnImages, hasLength(2));
  });

  test('HtmlUtils extracts lines and images', () {
    const html = '<p>Fits Alfa 147:2005-2014</p><p>&nbsp;</p><p>RAM 4+64G</p><img src="https://x/y.webp">';
    expect(HtmlUtils.toLines(html), ['Fits Alfa 147:2005-2014', 'RAM 4+64G']);
    expect(HtmlUtils.imageUrls(html), ['https://x/y.webp']);
  });
}

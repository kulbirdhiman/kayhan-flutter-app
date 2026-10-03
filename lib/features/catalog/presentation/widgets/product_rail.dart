import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../data/models/product.dart';
import 'product_card.dart';

/// Horizontal scrolling list of product cards.
class ProductRail extends StatelessWidget {
  const ProductRail({super.key, required this.products, this.loading = false});

  final List<Product> products;
  final bool loading;

  static const _cardWidth = 168.0;
  static const height = _cardWidth / productCardAspectRatio;

  @override
  Widget build(BuildContext context) {
    final count = loading ? 4 : products.length;
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: AppSpacing.page,
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, _) => AppSpacing.gapMd,
        itemBuilder: (_, i) => SizedBox(
          width: _cardWidth,
          child: loading ? const ProductCardSkeleton() : ProductCard(product: products[i]),
        ),
      ),
    );
  }
}

/// Responsive grid delegate: 2 columns on phones, more on tablets / web.
SliverGridDelegate productGridDelegate() => const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 240,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: productCardAspectRatio,
    );

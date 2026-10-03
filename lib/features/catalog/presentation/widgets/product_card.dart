import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../wishlist/presentation/wishlist_controller.dart';
import '../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.width});

  final Product product;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saved = context.select<WishlistController, bool>((w) => w.contains(product.id));

    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.product(product.slug)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: AppNetworkImage(product.thumbnail),
                    ),
                    if (product.onSale)
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: DiscountBadge(label: '-${product.discountPercent}%'),
                      )
                    else if (product.isPreOrder)
                      const Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: DiscountBadge(label: 'PRE-ORDER', color: AppColors.warning),
                      ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: IconButton(
                        tooltip: saved ? 'Remove from wishlist' : 'Save to wishlist',
                        visualDensity: VisualDensity.compact,
                        onPressed: () => context.read<WishlistController>().toggle(product),
                        icon: Icon(
                          saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 20,
                          color: saved ? AppColors.sale : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.3, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      PriceText(price: product.price, compareAt: product.onSale ? product.regularPrice : null),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card height relative to width, shared by grids and rails.
const productCardAspectRatio = 0.62;

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 1, child: _SkeletonFill()),
            AppSpacing.gapMd,
            _SkeletonLine(widthFactor: 0.9),
            AppSpacing.gapSm,
            _SkeletonLine(widthFactor: 0.6),
            Spacer(),
            _SkeletonLine(widthFactor: 0.4),
          ],
        ),
      ),
    );
  }
}

class _SkeletonFill extends StatelessWidget {
  const _SkeletonFill();

  @override
  Widget build(BuildContext context) => const _Pulse(child: SizedBox.expand());
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: widthFactor,
        child: const _Pulse(child: SizedBox(height: 12)),
      );
}

class _Pulse extends StatelessWidget {
  const _Pulse({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );
}

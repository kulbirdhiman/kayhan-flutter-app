import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/html_utils.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/bottom_action_bar.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../cart/presentation/cart_controller.dart';
import '../../../vehicle/presentation/garage_controller.dart';
import '../../../wishlist/presentation/wishlist_controller.dart';
import '../../data/catalog_repository.dart';
import '../../data/models/product.dart';
import '../widgets/image_gallery.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _future = _load();
  int _quantity = 1;

  Future<Product> _load() => context.read<CatalogRepository>().productBySlug(widget.slug);

  void _addToCart(Product product, {bool buyNow = false}) {
    context.read<CartController>().add(product, quantity: _quantity);
    if (buyNow) {
      context.go(AppRoutes.cart);
    } else {
      context.showMessage(
        'Added to cart',
        actionLabel: 'View cart',
        onAction: () => context.go(AppRoutes.cart),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: _future,
      builder: (context, snapshot) {
        final product = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            actions: [
              if (product != null) _WishlistButton(product: product),
              const _CartButton(),
            ],
          ),
          body: switch (snapshot.connectionState) {
            ConnectionState.waiting => const LoadingView(),
            _ when snapshot.hasError => MessageView.error(
                ApiException.from(snapshot.error!).message,
                onRetry: () => setState(() => _future = _load()),
              ),
            _ => _ProductBody(product: product!),
          },
          bottomNavigationBar: product == null
              ? null
              : BottomActionBar(
                  child: Row(
                    children: [
                      QuantityStepper(
                        value: _quantity,
                        onChanged: (v) => setState(() => _quantity = v),
                      ),
                      AppSpacing.gapMd,
                      Expanded(
                        child: OutlinedButton(
                          onPressed: product.inStock ? () => _addToCart(product) : null,
                          child: const Text('Add to cart'),
                        ),
                      ),
                      AppSpacing.gapSm,
                      Expanded(
                        child: FilledButton(
                          onPressed: product.inStock ? () => _addToCart(product, buyNow: true) : null,
                          child: Text(product.inStock ? 'Buy now' : 'Sold out'),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _ProductBody extends StatelessWidget {
  const _ProductBody({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final specs = HtmlUtils.toLines(product.specificationHtml);
    final descriptionImages = HtmlUtils.imageUrls(product.descriptionHtml).map(AppConfig.imageUrl).toList();
    final descriptionText = HtmlUtils.toLines(product.descriptionHtml);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        ImageGallery(images: product.images),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, AppSpacing.lg, AppSpacing.gutter, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _StockChip(product: product),
                  if (product.onSale) DiscountBadge(label: 'SAVE ${product.discountPercent}%'),
                ],
              ),
              AppSpacing.gapMd,
              Text(product.name, style: theme.textTheme.titleLarge?.copyWith(height: 1.25)),
              if (product.sku.isNotEmpty) ...[
                AppSpacing.gapXs,
                Text(
                  'SKU ${product.sku}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
              AppSpacing.gapLg,
              PriceText(
                price: product.price,
                compareAt: product.onSale ? product.regularPrice : null,
                size: PriceSize.large,
              ),
              Text(
                'Includes GST',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              AppSpacing.gapLg,
              _FitmentCard(product: product),
              AppSpacing.gapLg,
              const _PerksRow(),
            ],
          ),
        ),
        if (product.summary != null && product.summary!.isNotEmpty)
          _Section(
            title: 'Overview',
            initiallyExpanded: true,
            child: Text(product.summary!, style: theme.textTheme.bodyMedium?.copyWith(height: 1.55)),
          ),
        if (specs.isNotEmpty)
          _Section(
            title: 'Specifications',
            initiallyExpanded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in specs)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7, right: 10),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                          ),
                        ),
                        Expanded(child: Text(line, style: theme.textTheme.bodyMedium?.copyWith(height: 1.45))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        if (descriptionImages.isNotEmpty || descriptionText.isNotEmpty)
          _Section(
            title: 'Details',
            child: Column(
              children: [
                for (final line in descriptionText)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(line, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
                  ),
                for (final url in descriptionImages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppNetworkImage(url, fit: BoxFit.fitWidth, borderRadius: AppRadius.medium),
                  ),
              ],
            ),
          ),
        const _Section(
          title: 'Delivery & returns',
          child: Column(
            children: [
              _InfoLine(icon: Icons.local_shipping_outlined, text: 'Ships Australia-wide from local stock.'),
              _InfoLine(icon: Icons.assignment_return_outlined, text: 'Returns accepted in original condition.'),
              _InfoLine(icon: Icons.support_agent_outlined, text: 'Installation support from our team.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _StockChip extends StatelessWidget {
  const _StockChip({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final (label, color) = product.isPreOrder
        ? ('Pre-order', AppColors.warning)
        : product.inStock
            ? ('In stock', AppColors.success)
            : ('Out of stock', AppColors.sale);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

/// Shows whether the product fits the shopper's selected garage vehicle.
class _FitmentCard extends StatelessWidget {
  const _FitmentCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vehicle = context.watch<GarageController>().selected;

    final (IconData icon, Color color, String title, String body) = () {
      if (vehicle == null) {
        return (
          Icons.directions_car_outlined,
          theme.colorScheme.primary,
          'Check fitment',
          'Add your car to see if this part fits.',
        );
      }
      final fitsYear = vehicle.year == null ? null : product.fitsYear(vehicle.year!);
      final nameMatch = product.name.toLowerCase().contains(vehicle.modelName.toLowerCase()) &&
          product.name.toLowerCase().contains(vehicle.makeName.toLowerCase());
      if (nameMatch && fitsYear != false) {
        return (Icons.verified_rounded, AppColors.success, 'Fits your ${vehicle.label}', 'Matched to your garage vehicle.');
      }
      if (fitsYear == false || (product.yearFrom != null && !nameMatch)) {
        return (
          Icons.error_outline_rounded,
          AppColors.warning,
          'May not fit your ${vehicle.label}',
          'Check the specifications or contact us before ordering.',
        );
      }
      return (
        Icons.help_outline_rounded,
        theme.colorScheme.primary,
        'Fitment for ${vehicle.label}',
        'Check the specifications below to confirm compatibility.',
      );
    }();

    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: AppRadius.medium,
      child: InkWell(
        borderRadius: AppRadius.medium,
        onTap: () => vehicle == null ? context.push(AppRoutes.vehicleSelect) : context.go(AppRoutes.garage),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, color: color),
              AppSpacing.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    Text(
                      body,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerksRow extends StatelessWidget {
  const _PerksRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget perk(IconData icon, String label) => Expanded(
          child: Column(
            children: [
              Icon(icon, size: 22, color: theme.colorScheme.primary),
              AppSpacing.gapXs,
              Text(label, textAlign: TextAlign.center, style: theme.textTheme.labelSmall),
            ],
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: AppRadius.medium,
      ),
      child: Row(
        children: [
          perk(Icons.local_shipping_outlined, 'Fast AU\ndelivery'),
          perk(Icons.verified_user_outlined, 'Warranty\nincluded'),
          perk(Icons.build_outlined, 'Plug &\nplay fit'),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.initiallyExpanded = false});

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, AppSpacing.md, AppSpacing.gutter, 0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [child],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
          AppSpacing.gapMd,
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final saved = context.select<WishlistController, bool>((w) => w.contains(product.id));
    return IconButton(
      tooltip: saved ? 'Remove from wishlist' : 'Save to wishlist',
      onPressed: () => context.read<WishlistController>().toggle(product),
      icon: Icon(
        saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: saved ? AppColors.sale : null,
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartController, int>((c) => c.itemCount);
    return IconButton(
      tooltip: 'Cart',
      onPressed: () => context.go(AppRoutes.cart),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}

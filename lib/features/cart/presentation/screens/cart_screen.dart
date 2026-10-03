import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/config/store_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/bottom_action_bar.dart';
import '../../../../core/widgets/state_views.dart';
import '../cart_controller.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/order_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(cart.isEmpty ? 'Cart' : 'Cart (${cart.itemCount})'),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, cart),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: cart.isEmpty
          ? MessageView(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Browse head units, cameras and audio gear for your car.',
              actionLabel: 'Start shopping',
              onAction: () => context.go(AppRoutes.shop),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              children: [
                _FreeShippingProgress(subtotal: cart.subtotal),
                AppSpacing.gapMd,
                for (final item in cart.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: CartItemTile(
                      item: item,
                      onQuantityChanged: (q) => cart.setQuantity(item.productId, q),
                      onRemove: () {
                        final removed = cart.remove(item.productId);
                        if (removed == null) return;
                        context.showMessage(
                          'Removed from cart',
                          actionLabel: 'Undo',
                          onAction: () => cart.restore(removed),
                        );
                      },
                    ),
                  ),
                AppSpacing.gapMd,
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: OrderSummary(subtotal: cart.subtotal, savings: cart.savings),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : BottomActionBar(
              child: FilledButton(
                onPressed: () => context.push(AppRoutes.checkout),
                child: Text('Checkout · ${Formatters.money(cart.subtotal)}'),
              ),
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, CartController cart) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All items will be removed from your cart.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
        ],
      ),
    );
    if (ok == true) cart.clear();
  }
}

class _FreeShippingProgress extends StatelessWidget {
  const _FreeShippingProgress({required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const threshold = StoreConfig.freeShippingThreshold;
    final remaining = threshold - subtotal;
    final unlocked = remaining <= 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: (unlocked ? AppColors.success : theme.colorScheme.primary).withValues(alpha: 0.08),
        borderRadius: AppRadius.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: 20,
                color: unlocked ? AppColors.success : theme.colorScheme.primary,
              ),
              AppSpacing.gapSm,
              Expanded(
                child: Text(
                  unlocked
                      ? 'You’ve unlocked free standard delivery'
                      : 'Add ${Formatters.money(remaining)} for free standard delivery',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          AppSpacing.gapSm,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (subtotal / threshold).clamp(0, 1),
              minHeight: 6,
              color: unlocked ? AppColors.success : theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
            ),
          ),
        ],
      ),
    );
  }
}

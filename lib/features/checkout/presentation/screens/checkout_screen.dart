import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/config/store_config.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/bottom_action_bar.dart';
import '../../../../core/widgets/selectable_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../account/presentation/address_controller.dart';
import '../../../cart/presentation/cart_controller.dart';
import '../../../cart/presentation/widgets/cart_item_tile.dart';
import '../../../cart/presentation/widgets/order_summary.dart';
import '../../../orders/data/models/order.dart';
import '../../../orders/presentation/orders_controller.dart';

/// Single-page checkout: address → delivery → payment → review.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _addressId;
  String _shippingId = StoreConfig.shippingMethods.first.id;
  PaymentMethod _payment = PaymentMethod.card;
  final _note = TextEditingController();
  bool _placing = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cart = context.read<CartController>();
    final address = context.read<AddressController>().byId(_addressId ?? '') ??
        context.read<AddressController>().defaultAddress;
    if (address == null) {
      context.showMessage('Add a delivery address to continue');
      return;
    }

    setState(() => _placing = true);
    final method = ShippingMethod.byId(_shippingId);
    final order = Order(
      id: 'KA${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}${Random().nextInt(9)}',
      createdAt: DateTime.now(),
      items: cart.items,
      address: address,
      shippingMethodId: method.id,
      shippingMethodName: method.name,
      payment: _payment,
      subtotal: cart.subtotal,
      shipping: method.costFor(cart.subtotal),
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );

    try {
      final placed = await context.read<OrdersController>().place(order);
      if (!mounted) return;
      context.go(AppRoutes.orderSuccess(placed.id));
      cart.clear();
    } catch (e) {
      if (mounted) context.showMessage('Could not place order. Please try again.');
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartController>();
    final addresses = context.watch<AddressController>();
    final selectedAddress = addresses.byId(_addressId ?? '') ?? addresses.defaultAddress;
    final method = ShippingMethod.byId(_shippingId);
    final shipping = method.costFor(cart.subtotal);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: MessageView(
          icon: Icons.shopping_bag_outlined,
          title: 'Your cart is empty',
          actionLabel: 'Continue shopping',
          onAction: () => context.go(AppRoutes.home),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          const _StepTitle(number: 1, title: 'Delivery address'),
          if (addresses.items.isEmpty)
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.addressNew),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Add delivery address'),
            )
          else ...[
            for (final a in addresses.items)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: SelectableCard(
                  selected: a.id == selectedAddress?.id,
                  onTap: () => setState(() => _addressId = a.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.fullName, style: theme.textTheme.titleSmall),
                      Text(a.singleLine, style: theme.textTheme.bodySmall),
                      Text(a.phone, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.push(AppRoutes.addressNew),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add new address'),
              ),
            ),
          ],
          AppSpacing.gapLg,
          const _StepTitle(number: 2, title: 'Delivery method'),
          for (final m in StoreConfig.shippingMethods)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SelectableCard(
                selected: m.id == _shippingId,
                onTap: () => setState(() => _shippingId = m.id),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name, style: theme.textTheme.titleSmall),
                          Text(m.eta, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Text(
                      m.costFor(cart.subtotal) == 0 ? 'Free' : Formatters.money(m.costFor(cart.subtotal)),
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
          AppSpacing.gapLg,
          const _StepTitle(number: 3, title: 'Payment'),
          for (final p in PaymentMethod.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SelectableCard(
                selected: p == _payment,
                onTap: () => setState(() => _payment = p),
                leading: Icon(_paymentIcon(p)),
                child: Text(p.label, style: theme.textTheme.titleSmall),
              ),
            ),
          AppSpacing.gapLg,
          const _StepTitle(number: 4, title: 'Review order'),
          for (final item in cart.items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: CartItemTile(item: item),
            ),
          AppSpacing.gapSm,
          TextField(
            controller: _note,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Order notes (optional)',
              hintText: 'e.g. vehicle VIN, installation questions',
            ),
          ),
          AppSpacing.gapLg,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: OrderSummary(subtotal: cart.subtotal, savings: cart.savings, shipping: shipping),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(
          onPressed: _placing || selectedAddress == null ? null : _placeOrder,
          child: _placing
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
              : Text('Place order · ${Formatters.money(cart.subtotal + shipping)}'),
        ),
      ),
    );
  }

  IconData _paymentIcon(PaymentMethod p) => switch (p) {
        PaymentMethod.card => Icons.credit_card_rounded,
        PaymentMethod.paypal => Icons.account_balance_wallet_outlined,
        PaymentMethod.afterpay => Icons.schedule_rounded,
        PaymentMethod.bankTransfer => Icons.account_balance_outlined,
      };
}

class _StepTitle extends StatelessWidget {
  const _StepTitle({required this.number, required this.title});

  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              '$number',
              style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          AppSpacing.gapSm,
          Text(title, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

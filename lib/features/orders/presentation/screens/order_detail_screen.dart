import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../cart/presentation/widgets/cart_item_tile.dart';
import '../../../cart/presentation/widgets/order_summary.dart';
import '../../data/models/order.dart';
import '../orders_controller.dart';
import '../widgets/order_status_chip.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    final orders = context.read<OrdersController>();
    if (orders.byId(widget.orderId) == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => orders.load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrdersController>();
    final order = controller.byId(widget.orderId);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Order #${widget.orderId}')),
      body: order == null
          ? (controller.state.isLoading || controller.state.data == null
              ? const LoadingView()
              : const MessageView(icon: Icons.receipt_long_outlined, title: 'Order not found'))
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Placed ${Formatters.dateTime(order.createdAt)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            OrderStatusChip(status: order.status),
                          ],
                        ),
                        AppSpacing.gapLg,
                        _StatusTimeline(status: order.status),
                      ],
                    ),
                  ),
                ),
                AppSpacing.gapMd,
                _InfoCard(
                  icon: Icons.location_on_outlined,
                  title: 'Delivery to',
                  lines: [order.address.fullName, order.address.singleLine, order.address.phone],
                ),
                AppSpacing.gapMd,
                _InfoCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'Delivery & payment',
                  lines: [order.shippingMethodName, order.payment.label, if (order.note != null) 'Note: ${order.note}'],
                ),
                AppSpacing.gapLg,
                Text('Items', style: theme.textTheme.titleMedium),
                AppSpacing.gapSm,
                for (final item in order.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: CartItemTile(item: item),
                  ),
                AppSpacing.gapSm,
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: OrderSummary(subtotal: order.subtotal, shipping: order.shipping),
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.status});

  final OrderStatus status;

  static const _steps = [OrderStatus.placed, OrderStatus.processing, OrderStatus.shipped, OrderStatus.delivered];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = _steps.indexOf(status);
    return Row(
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Icon(
                  i <= current ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: i <= current ? AppColors.success : theme.colorScheme.outline,
                ),
                AppSpacing.gapXs,
                Text(_steps[i].label, textAlign: TextAlign.center, style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.lines});

  final IconData icon;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            AppSpacing.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  AppSpacing.gapXs,
                  for (final l in lines) Text(l, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

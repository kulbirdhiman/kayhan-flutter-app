import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/state_views.dart';
import '../../data/models/order.dart';
import '../orders_controller.dart';
import '../widgets/order_status_chip.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<OrdersController>().load());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrdersController>().state;
    final orders = state.data ?? const <Order>[];

    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: switch (state) {
        _ when state.isLoading && orders.isEmpty => const LoadingView(),
        _ when state.hasError && orders.isEmpty =>
          MessageView.error(state.error!, onRetry: context.read<OrdersController>().load),
        _ when orders.isEmpty => MessageView(
            icon: Icons.receipt_long_outlined,
            title: 'No orders yet',
            message: 'When you place an order it will show up here.',
            actionLabel: 'Start shopping',
            onAction: () => context.go(AppRoutes.shop),
          ),
        _ => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            itemCount: orders.length,
            separatorBuilder: (_, _) => AppSpacing.gapSm,
            itemBuilder: (_, i) => _OrderCard(order: orders[i]),
          ),
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: AppRadius.large,
        onTap: () => context.push(AppRoutes.order(order.id)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('#${order.id}', style: theme.textTheme.titleSmall)),
                  OrderStatusChip(status: order.status),
                ],
              ),
              Text(
                Formatters.dateTime(order.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              AppSpacing.gapMd,
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    for (final item in order.items.take(4))
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: AppNetworkImage(item.image, width: 52, height: 52, borderRadius: AppRadius.small),
                      ),
                    if (order.items.length > 4) Text('+${order.items.length - 4}'),
                  ],
                ),
              ),
              AppSpacing.gapMd,
              Row(
                children: [
                  Text('${order.itemCount} item${order.itemCount == 1 ? '' : 's'}', style: theme.textTheme.bodySmall),
                  const Spacer(),
                  Text(Formatters.money(order.total), style: theme.textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

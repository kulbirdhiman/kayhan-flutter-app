import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, size: 52, color: AppColors.success),
              ),
              AppSpacing.gapXl,
              Text('Order placed!', style: theme.textTheme.headlineMedium),
              AppSpacing.gapSm,
              Text(
                'Thanks for shopping with Kayhan Audio. Your order number is',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              AppSpacing.gapSm,
              SelectableText(orderId, style: theme.textTheme.titleLarge),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.order(orderId)),
                child: const Text('View order'),
              ),
              AppSpacing.gapMd,
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Continue shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

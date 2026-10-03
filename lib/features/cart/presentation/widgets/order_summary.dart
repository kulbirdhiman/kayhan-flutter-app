import 'package:flutter/material.dart';

import '../../../../core/config/store_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';

/// Subtotal / savings / shipping / GST / total breakdown.
class OrderSummary extends StatelessWidget {
  const OrderSummary({
    super.key,
    required this.subtotal,
    this.savings = 0,
    this.shipping,
  });

  final double subtotal;
  final double savings;

  /// `null` means shipping is calculated at checkout.
  final double? shipping;

  double get total => subtotal + (shipping ?? 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    Widget row(String label, String value, {TextStyle? style, Color? color}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(child: Text(label, style: style ?? muted)),
              Text(value, style: (style ?? theme.textTheme.bodyMedium)?.copyWith(color: color)),
            ],
          ),
        );

    return Column(
      children: [
        row('Subtotal', Formatters.money(subtotal + savings)),
        if (savings > 0) row('You save', '-${Formatters.money(savings)}', color: AppColors.sale),
        row(
          'Shipping',
          shipping == null
              ? 'Calculated at checkout'
              : shipping == 0
                  ? 'Free'
                  : Formatters.money(shipping!),
          color: shipping == 0 ? AppColors.success : null,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.sm), child: Divider()),
        row('Total', Formatters.money(total), style: theme.textTheme.titleMedium),
        row('Includes GST', Formatters.money(total / StoreConfig.gstDivisor)),
      ],
    );
  }
}

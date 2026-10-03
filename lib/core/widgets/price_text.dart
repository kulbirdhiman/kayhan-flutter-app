import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatters.dart';

/// Current price with optional struck-through compare-at price.
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.compareAt,
    this.size = PriceSize.medium,
  });

  final double price;
  final double? compareAt;
  final PriceSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSale = compareAt != null && compareAt! > price;
    final main = switch (size) {
      PriceSize.small => theme.textTheme.titleSmall,
      PriceSize.medium => theme.textTheme.titleMedium,
      PriceSize.large => theme.textTheme.headlineSmall,
    };

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 6,
      children: [
        Text(
          Formatters.price(price),
          style: main?.copyWith(
            fontWeight: FontWeight.w800,
            color: onSale ? AppColors.sale : theme.colorScheme.onSurface,
          ),
        ),
        if (onSale)
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(
              Formatters.price(compareAt!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
      ],
    );
  }
}

enum PriceSize { small, medium, large }

class DiscountBadge extends StatelessWidget {
  const DiscountBadge({super.key, required this.label, this.color = AppColors.sale});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

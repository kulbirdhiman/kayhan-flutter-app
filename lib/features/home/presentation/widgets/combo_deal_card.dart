import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../catalog/data/models/combo_deal.dart';

class ComboDealCard extends StatelessWidget {
  const ComboDealCard({super.key, required this.deal});

  final ComboDeal deal;

  static const width = 290.0;
  static const height = 296.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.product(deal.slug)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: AppNetworkImage(deal.image, borderRadius: AppRadius.small)),
                      if (deal.addOnImages.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.add_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              for (final img in deal.addOnImages.take(2))
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: AppNetworkImage(img, borderRadius: AppRadius.small),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                AppSpacing.gapMd,
                const DiscountBadge(label: 'COMBO'),
                AppSpacing.gapSm,
                Text(
                  deal.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.3),
                ),
                if (deal.addOnName.isNotEmpty)
                  Text(
                    '+ ${deal.addOnName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                const Spacer(),
                PriceText(price: deal.finalPrice, compareAt: deal.dealPrice == null ? null : deal.price),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

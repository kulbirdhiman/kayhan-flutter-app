import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../../data/models/cart_item.dart';
import '../cart_controller.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    this.onQuantityChanged,
    this.onRemove,
  });

  final CartItem item;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onRemove;

  bool get _editable => onQuantityChanged != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: AppRadius.large,
        onTap: () => context.push(AppRoutes.product(item.slug)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNetworkImage(item.image, width: 84, height: 84, borderRadius: AppRadius.small),
              AppSpacing.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.3),
                    ),
                    AppSpacing.gapXs,
                    PriceText(price: item.unitPrice, compareAt: item.compareAtPrice, size: PriceSize.small),
                    AppSpacing.gapSm,
                    if (_editable)
                      Row(
                        children: [
                          QuantityStepper(
                            compact: true,
                            value: item.quantity,
                            max: CartController.maxQuantity,
                            onChanged: onQuantityChanged!,
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Remove',
                            onPressed: onRemove,
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      )
                    else
                      Text('Qty ${item.quantity}', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../vehicle/presentation/garage_controller.dart';

/// "Shopping for 2014 Ford Ranger" / "Add your car" strip.
class VehicleBar extends StatelessWidget {
  const VehicleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vehicle = context.watch<GarageController>().selected;

    return Material(
      color: AppColors.ink,
      borderRadius: AppRadius.medium,
      child: InkWell(
        borderRadius: AppRadius.medium,
        onTap: () => vehicle == null
            ? context.push(AppRoutes.vehicleSelect)
            : context.push(AppRoutes.productList(title: vehicle.label, query: vehicle.searchQuery)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.directions_car_filled_rounded, color: AppColors.primaryBright),
              AppSpacing.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle == null ? 'Shop by vehicle' : 'Parts for your car',
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.white60),
                    ),
                    Text(
                      vehicle?.label ?? 'Add your car to find parts that fit',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (vehicle != null)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: AppColors.primaryBright),
                  onPressed: () => context.go(AppRoutes.garage),
                  child: const Text('Change'),
                )
              else
                const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryBright),
            ],
          ),
        ),
      ),
    );
  }
}

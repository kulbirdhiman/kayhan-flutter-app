import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/state_views.dart';
import '../../data/models/vehicle.dart';
import '../garage_controller.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final garage = context.watch<GarageController>();
    final selected = garage.selected;

    return Scaffold(
      appBar: AppBar(title: const Text('My garage')),
      floatingActionButton: garage.vehicles.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.vehicleSelect),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add vehicle'),
            ),
      body: garage.vehicles.isEmpty
          ? MessageView(
              icon: Icons.directions_car_filled_rounded,
              title: 'Your garage is empty',
              message: 'Add your car once and we’ll show parts that fit it across the store.',
              actionLabel: 'Add my car',
              onAction: () => context.push(AppRoutes.vehicleSelect),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, AppSpacing.sm, AppSpacing.gutter, 96),
              children: [
                if (selected != null) _ActiveVehicleCard(vehicle: selected),
                AppSpacing.gapXl,
                Text('Saved vehicles', style: Theme.of(context).textTheme.titleMedium),
                AppSpacing.gapSm,
                for (final v in garage.vehicles)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.xs),
                        leading: Icon(
                          v.id == selected?.id ? Icons.check_circle_rounded : Icons.directions_car_outlined,
                          color: v.id == selected?.id ? AppColors.success : null,
                        ),
                        title: Text(v.label),
                        subtitle: Text(v.id == selected?.id ? 'Active vehicle' : 'Tap to make active'),
                        onTap: () => garage.select(v),
                        trailing: IconButton(
                          tooltip: 'Remove',
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () => garage.remove(v),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ActiveVehicleCard extends StatelessWidget {
  const _ActiveVehicleCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        gradient: const LinearGradient(
          colors: [AppColors.ink, Color(0xFF13324D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_car_filled_rounded, color: AppColors.primaryBright),
              AppSpacing.gapSm,
              Text(
                'SHOPPING FOR',
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70, letterSpacing: 1.2),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Text(vehicle.label, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white)),
          AppSpacing.gapLg,
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBright,
              foregroundColor: AppColors.ink,
            ),
            onPressed: () => context.push(
              AppRoutes.productList(title: vehicle.label, query: vehicle.searchQuery),
            ),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Shop parts for this car'),
          ),
        ],
      ),
    );
  }
}

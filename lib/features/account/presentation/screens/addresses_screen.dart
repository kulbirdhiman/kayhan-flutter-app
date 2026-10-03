import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/state_views.dart';
import '../address_controller.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddressController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Addresses')),
      floatingActionButton: controller.items.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.addressNew),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add address'),
            ),
      body: controller.items.isEmpty
          ? MessageView(
              icon: Icons.location_on_outlined,
              title: 'No saved addresses',
              message: 'Save a delivery address to speed up checkout.',
              actionLabel: 'Add address',
              onAction: () => context.push(AppRoutes.addressNew),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, AppSpacing.sm, AppSpacing.gutter, 96),
              itemCount: controller.items.length,
              separatorBuilder: (_, _) => AppSpacing.gapSm,
              itemBuilder: (_, i) {
                final a = controller.items[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.xs, AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(child: Text(a.fullName, style: theme.textTheme.titleSmall)),
                                  if (a.isDefault) ...[
                                    AppSpacing.gapSm,
                                    Chip(
                                      label: const Text('Default'),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                      labelStyle: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ],
                              ),
                              AppSpacing.gapXs,
                              Text(a.singleLine, style: theme.textTheme.bodyMedium),
                              Text(a.phone, style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Address options',
                          onSelected: (value) => switch (value) {
                            'edit' => context.push(AppRoutes.addressEdit(a.id)),
                            'default' => controller.setDefault(a.id),
                            'delete' => controller.remove(a.id),
                            _ => null,
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            if (!a.isDefault) const PopupMenuItem(value: 'default', child: Text('Set as default')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

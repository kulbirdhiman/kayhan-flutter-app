import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../catalog/data/models/department.dart';

class DepartmentStrip extends StatelessWidget {
  const DepartmentStrip({super.key, required this.departments, this.loading = false});

  final List<Department> departments;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 96,
      child: ListView.separated(
        padding: AppSpacing.page,
        scrollDirection: Axis.horizontal,
        itemCount: loading ? 6 : departments.length,
        separatorBuilder: (_, _) => AppSpacing.gapSm,
        itemBuilder: (_, i) {
          if (loading) {
            return const Column(
              children: [Skeleton(width: 60, height: 60, radius: 18), AppSpacing.gapSm, Skeleton(width: 56, height: 10)],
            );
          }
          final d = departments[i];
          return SizedBox(
            width: 76,
            child: InkWell(
              borderRadius: AppRadius.medium,
              onTap: () => context.push(AppRoutes.productList(title: d.name, query: d.searchTerm)),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Icon(d.icon, color: theme.colorScheme.primary, size: 26),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    d.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(height: 1.15),
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

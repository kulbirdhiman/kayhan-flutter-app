import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Tappable fake search bar that opens the search screen.
class SearchFieldButton extends StatelessWidget {
  const SearchFieldButton({super.key, required this.onTap, this.hint = 'Search stereos, cameras, speakers…'});

  final VoidCallback onTap;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadius.medium,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.medium,
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: theme.colorScheme.onSurfaceVariant),
              AppSpacing.gapMd,
              Expanded(
                child: Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

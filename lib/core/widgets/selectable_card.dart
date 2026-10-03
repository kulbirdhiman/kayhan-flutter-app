import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Card that acts like a radio option (shipping, payment, address choice).
class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
    this.leading,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.primary.withValues(alpha: 0.06) : scheme.surface,
        borderRadius: AppRadius.medium,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.medium,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: AppRadius.medium,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outline,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                AppSpacing.gapMd,
                if (leading != null) ...[leading!, AppSpacing.gapMd],
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

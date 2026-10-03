import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Shared layout for sign-in / sign-up / reset screens.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _BrandMark(),
                  AppSpacing.gapXl,
                  Text(title, style: theme.textTheme.headlineMedium),
                  AppSpacing.gapSm,
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  AppSpacing.gapXl,
                  child,
                  if (footer != null) ...[AppSpacing.gapXl, footer!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: AppColors.ink, borderRadius: AppRadius.medium),
          child: const Icon(Icons.graphic_eq_rounded, color: AppColors.primaryBright),
        ),
        AppSpacing.gapMd,
        Text(
          'KAYHAN AUDIO',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(letterSpacing: 2, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

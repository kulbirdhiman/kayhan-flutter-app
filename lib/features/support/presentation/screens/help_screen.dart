import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// FAQ page. Answers are generic placeholders — have the Kayhan team
/// review them against the store's actual policies before release.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      'How do I know a part fits my car?',
      'Add your car under My Garage. Product pages then show a fitment check, and the specifications list '
          'the exact makes, models and years each unit is built for.',
    ),
    (
      'Do I need a professional installer?',
      'Most vehicle-specific head units are plug-and-play with the supplied harness and fascia. '
          'If you’re unsure, contact our team before ordering.',
    ),
    (
      'Will I keep my steering wheel controls and reversing camera?',
      'Vehicle-specific units are designed to retain factory features. Check the specification list '
          'on the product page for your model.',
    ),
    (
      'How long does delivery take?',
      'Delivery times are shown at checkout for each delivery option.',
    ),
    (
      'How do returns work?',
      'Contact us with your order number. Items should be returned unused, in original packaging.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQs')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          Text('Frequently asked questions', style: theme.textTheme.titleMedium),
          AppSpacing.gapSm,
          Card(
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  for (var i = 0; i < _faqs.length; i++) ...[
                    if (i > 0) const Divider(),
                    ExpansionTile(
                      title: Text(_faqs[i].$1, style: theme.textTheme.titleSmall),
                      childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                      expandedAlignment: Alignment.centerLeft,
                      children: [Text(_faqs[i].$2, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5))],
                    ),
                  ],
                ],
              ),
            ),
          ),
          AppSpacing.gapXl,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(Icons.support_agent_rounded, size: 32, color: theme.colorScheme.primary),
                  AppSpacing.gapLg,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Still need help?', style: theme.textTheme.titleSmall),
                        Text(
                          'Visit kayhanaudio.com.au to contact our team.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

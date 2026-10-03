import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../catalog/presentation/widgets/product_rail.dart';
import '../home_controller.dart';

/// Section header + chip tabs + horizontal product rail.
class TabbedProductRail extends StatefulWidget {
  const TabbedProductRail({
    super.key,
    required this.title,
    required this.groups,
    this.subtitle,
    this.loading = false,
  });

  final String title;
  final String? subtitle;
  final ProductGroups groups;
  final bool loading;

  @override
  State<TabbedProductRail> createState() => _TabbedProductRailState();
}

class _TabbedProductRailState extends State<TabbedProductRail> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final labels = widget.groups.keys.toList();
    final selected = labels.contains(_selected) ? _selected! : (labels.isEmpty ? null : labels.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          onAction: selected == null
              ? null
              : () => context.push(AppRoutes.productList(title: selected, query: _searchTerm(selected))),
        ),
        AppSpacing.gapMd,
        if (labels.length > 1)
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: AppSpacing.page,
              scrollDirection: Axis.horizontal,
              itemCount: labels.length,
              separatorBuilder: (_, _) => AppSpacing.gapSm,
              itemBuilder: (_, i) => ChoiceChip(
                label: Text(labels[i]),
                selected: labels[i] == selected,
                showCheckmark: false,
                onSelected: (_) => setState(() => _selected = labels[i]),
              ),
            ),
          ),
        if (labels.length > 1) AppSpacing.gapMd,
        ProductRail(
          loading: widget.loading && selected == null,
          products: selected == null ? const [] : widget.groups[selected]!,
        ),
      ],
    );
  }

  /// Turns a tab label like "Android stereos" into a search keyword.
  String _searchTerm(String label) => switch (label) {
        'Android stereos' => 'SatNav',
        'CarPlay modules' => 'CarPlay',
        'Linux head units' => 'Linux',
        'Sub boxes' => 'Subwoofer Box',
        'Subwoofers' => 'Subwoofer',
        'Fascias' => 'Fascia',
        'Wiring' => 'Harness',
        'Batteries' => 'Battery',
        _ => label.replaceAll(RegExp(r's$'), ''),
      };
}

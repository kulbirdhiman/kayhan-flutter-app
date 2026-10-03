import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/storage/local_storage.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/debouncer.dart';
import '../../data/catalog_repository.dart';
import '../product_list_controller.dart';
import '../widgets/paged_product_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _popular = [
    'CarPlay', 'SatNav', 'Reversing camera', 'Dash cam', 'Amplifier', //
    'Subwoofer', 'Speakers', 'Fascia', 'Steering wheel', 'Digital cluster',
  ];
  static const _maxRecent = 8;

  late final TextEditingController _text = TextEditingController(text: widget.initialQuery);
  late final ProductListController _results = ProductListController(context.read<CatalogRepository>());
  late final LocalStorage _storage = context.read<LocalStorage>();
  final _debouncer = Debouncer();
  late List<String> _recent = _storage.getStringList(LocalStorage.recentSearches);
  String _query = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery?.isNotEmpty ?? false) _submit(widget.initialQuery!);
  }

  @override
  void dispose() {
    _text.dispose();
    _results.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    _debouncer(() {
      if (value.trim().length >= 2) _search(value.trim());
    });
  }

  void _submit(String value) {
    final q = value.trim();
    if (q.isEmpty) return;
    _text.text = q;
    _rememberSearch(q);
    _search(q);
  }

  void _search(String q) {
    if (q == _query) return;
    setState(() => _query = q);
    _results.refresh(query: q);
  }

  void _rememberSearch(String q) {
    _recent = [q, ..._recent.where((r) => r.toLowerCase() != q.toLowerCase())].take(_maxRecent).toList();
    _storage.setStringList(LocalStorage.recentSearches, _recent);
  }

  void _clearRecent() {
    setState(() => _recent = []);
    _storage.setStringList(LocalStorage.recentSearches, []);
  }

  void _clear() {
    _text.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.gutter),
          child: TextField(
            controller: _text,
            autofocus: widget.initialQuery == null,
            textInputAction: TextInputAction.search,
            onChanged: _onChanged,
            onSubmitted: _submit,
            decoration: InputDecoration(
              hintText: 'Search products, makes, models…',
              prefixIcon: const Icon(Icons.search_rounded),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              suffixIcon: _text.text.isEmpty
                  ? null
                  : IconButton(tooltip: 'Clear', icon: const Icon(Icons.close_rounded), onPressed: _clear),
            ),
          ),
        ),
      ),
      body: _query.isEmpty
          ? _Suggestions(
              recent: _recent,
              popular: _popular,
              onSelect: _submit,
              onClearRecent: _clearRecent,
            )
          : PagedProductGrid(
              controller: _results,
              emptyMessage: 'Nothing matched “$_query”. Try a car make, model or product type.',
            ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({
    required this.recent,
    required this.popular,
    required this.onSelect,
    required this.onClearRecent,
  });

  final List<String> recent;
  final List<String> popular;
  final ValueChanged<String> onSelect;
  final VoidCallback onClearRecent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: [
        if (recent.isNotEmpty) ...[
          Row(
            children: [
              Expanded(child: Text('Recent searches', style: theme.textTheme.titleMedium)),
              TextButton(onPressed: onClearRecent, child: const Text('Clear')),
            ],
          ),
          for (final r in recent)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history_rounded),
              title: Text(r),
              trailing: const Icon(Icons.north_west_rounded, size: 18),
              onTap: () => onSelect(r),
            ),
          AppSpacing.gapLg,
        ],
        Text('Popular searches', style: theme.textTheme.titleMedium),
        AppSpacing.gapMd,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final p in popular)
              ActionChip(
                avatar: const Icon(Icons.trending_up_rounded, size: 16),
                label: Text(p),
                onPressed: () => onSelect(p),
              ),
          ],
        ),
      ],
    );
  }
}

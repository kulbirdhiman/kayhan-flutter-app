import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/bottom_action_bar.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../catalog/data/models/category.dart';
import '../../data/models/vehicle.dart';
import '../../data/vehicle_repository.dart';
import '../garage_controller.dart';

/// Make → Model → Year picker. Saves the vehicle and opens matching parts.
class VehicleSelectorScreen extends StatefulWidget {
  const VehicleSelectorScreen({super.key, this.initialMakeId});

  final int? initialMakeId;

  @override
  State<VehicleSelectorScreen> createState() => _VehicleSelectorScreenState();
}

class _VehicleSelectorScreenState extends State<VehicleSelectorScreen> {
  late final VehicleRepository _repo = context.read<VehicleRepository>();

  List<Category>? _makes;
  List<CarModel>? _models;
  List<int>? _years;

  Category? _make;
  CarModel? _model;
  int? _year;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMakes();
  }

  Future<void> _run(Future<void> Function() task) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await task();
    } catch (e) {
      _error = ApiException.from(e).message;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMakes() => _run(() async {
        _makes = await _repo.makes();
        final preset = _makes!.where((m) => m.id == widget.initialMakeId);
        if (preset.isNotEmpty) await _pickMake(preset.first, inner: true);
      });

  Future<void> _pickMake(Category make, {bool inner = false}) async {
    Future<void> task() async {
      _make = make;
      _model = null;
      _year = null;
      _models = null;
      _years = null;
      _models = await _repo.models(make);
    }

    inner ? await task() : await _run(task);
  }

  Future<void> _pickModel(CarModel model) => _run(() async {
        _model = model;
        _year = null;
        _years = null;
        _years = await _repo.years(model.id);
      });

  void _save() {
    final vehicle = Vehicle(
      makeId: _make!.id,
      makeName: _make!.name,
      modelId: _model!.id,
      modelName: _model!.name,
      year: _year,
    );
    context.read<GarageController>().add(vehicle);
    context.pushReplacement(AppRoutes.productList(title: vehicle.label, query: vehicle.searchQuery));
  }

  Future<T?> _choose<T>(String title, List<T> options, String Function(T) label) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _OptionSheet<T>(title: title, options: options, label: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Shop by vehicle')),
      body: _makes == null && _loading
          ? const LoadingView()
          : _makes == null && _error != null
              ? MessageView.error(_error!, onRetry: _loadMakes)
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  children: [
                    Text('Find parts that fit', style: theme.textTheme.headlineSmall),
                    AppSpacing.gapXs,
                    Text(
                      'Tell us about your car and we’ll show compatible stereos, fascias and accessories.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    AppSpacing.gapXl,
                    _StepField(
                      step: 1,
                      label: 'Make',
                      value: _make?.name,
                      enabled: _makes != null,
                      onTap: () async {
                        final m = await _choose('Select make', _makes!, (c) => c.name);
                        if (m != null) _pickMake(m);
                      },
                    ),
                    AppSpacing.gapMd,
                    _StepField(
                      step: 2,
                      label: 'Model',
                      value: _model?.name,
                      enabled: _models != null && _models!.isNotEmpty,
                      hint: _make != null && _models != null && _models!.isEmpty ? 'No models listed for this make' : null,
                      onTap: () async {
                        final m = await _choose('Select model', _models!, (c) => c.name);
                        if (m != null) _pickModel(m);
                      },
                    ),
                    AppSpacing.gapMd,
                    _StepField(
                      step: 3,
                      label: 'Year (optional)',
                      value: _year?.toString(),
                      enabled: _years != null && _years!.isNotEmpty,
                      onTap: () async {
                        final y = await _choose('Select year', _years!, (y) => '$y');
                        if (y != null) setState(() => _year = y);
                      },
                    ),
                    if (_loading) ...[AppSpacing.gapXl, const LoadingView()],
                    if (_error != null && _makes != null) ...[
                      AppSpacing.gapLg,
                      Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                    ],
                  ],
                ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton.icon(
          onPressed: _make != null && _model != null && !_loading ? _save : null,
          icon: const Icon(Icons.search_rounded),
          label: const Text('Save & find parts'),
        ),
      ),
    );
  }
}

class _StepField extends StatelessWidget {
  const _StepField({
    required this.step,
    required this.label,
    required this.value,
    required this.enabled,
    required this.onTap,
    this.hint,
  });

  final int step;
  final String label;
  final String? value;
  final bool enabled;
  final VoidCallback onTap;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = value != null;
    return Opacity(
      opacity: enabled || done ? 1 : 0.5,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.medium,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: AppRadius.medium,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: AppRadius.medium,
              border: Border.all(color: done ? theme.colorScheme.primary : theme.colorScheme.outline),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: done ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHigh,
                  child: done
                      ? Icon(Icons.check_rounded, size: 16, color: theme.colorScheme.onPrimary)
                      : Text('$step', style: theme.textTheme.labelMedium),
                ),
                AppSpacing.gapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      Text(value ?? hint ?? 'Select', style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
                const Icon(Icons.expand_more_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Searchable option list shown in a bottom sheet.
class _OptionSheet<T> extends StatefulWidget {
  const _OptionSheet({required this.title, required this.options, required this.label});

  final String title;
  final List<T> options;
  final String Function(T) label;

  @override
  State<_OptionSheet<T>> createState() => _OptionSheetState<T>();
}

class _OptionSheetState<T> extends State<_OptionSheet<T>> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.options
        .where((o) => widget.label(o).toLowerCase().contains(_filter.toLowerCase()))
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 0, AppSpacing.gutter, AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
                if (widget.options.length > 8) ...[
                  AppSpacing.gapMd,
                  TextField(
                    autofocus: false,
                    onChanged: (v) => setState(() => _filter = v),
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search_rounded),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scroll,
              itemCount: filtered.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(widget.label(filtered[i])),
                onTap: () => Navigator.pop(context, filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

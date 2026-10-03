import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/search_field_button.dart';
import '../../../../core/widgets/state_views.dart';
import '../../data/catalog_repository.dart';
import '../../data/models/category.dart';
import '../../data/models/department.dart';

/// "Shop" tab: browse by department, product type or car make.
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late Future<(List<Department>, List<Category>)> _future = _load();

  Future<(List<Department>, List<Category>)> _load() async {
    final repo = context.read<CatalogRepository>();
    final results = await Future.wait([repo.departments(), repo.categories()]);
    return (results[0] as List<Department>, results[1] as List<Category>);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(118),
            child: Column(
              children: [
                Padding(
                  padding: AppSpacing.page,
                  child: SearchFieldButton(onTap: () => context.push(AppRoutes.search)),
                ),
                AppSpacing.gapSm,
                const TabBar(
                  tabAlignment: TabAlignment.fill,
                  tabs: [Tab(text: 'Departments'), Tab(text: 'Product types'), Tab(text: 'Car makes')],
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
            if (snapshot.hasError) {
              return MessageView.error(
                ApiException.from(snapshot.error!).message,
                onRetry: () => setState(() => _future = _load()),
              );
            }
            final (departments, categories) = snapshot.data!;
            return TabBarView(
              children: [
                _DepartmentGrid(departments: departments),
                _CategoryList(categories: categories.where((c) => c.isProductType).toList()),
                _MakeGrid(makes: categories.where((c) => c.isCarMake).toList()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DepartmentGrid extends StatelessWidget {
  const _DepartmentGrid({required this.departments});

  final List<Department> departments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.15,
      ),
      itemCount: departments.length,
      itemBuilder: (_, i) {
        final d = departments[i];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push(AppRoutes.productList(title: d.name, query: d.searchTerm)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.medium,
                    ),
                    child: Icon(d.icon, color: theme.colorScheme.primary),
                  ),
                  const Spacer(),
                  Text(d.name, style: theme.textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: categories.length,
      separatorBuilder: (_, _) => const Divider(indent: AppSpacing.gutter),
      itemBuilder: (_, i) {
        final c = categories[i];
        return ListTile(
          title: Text(c.name),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push(AppRoutes.productList(title: c.name, query: c.name)),
        );
      },
    );
  }
}

class _MakeGrid extends StatelessWidget {
  const _MakeGrid({required this.makes});

  final List<Category> makes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 2.4,
      ),
      itemCount: makes.length,
      itemBuilder: (_, i) {
        final m = makes[i];
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            backgroundColor: theme.colorScheme.surface,
          ),
          onPressed: () => context.push(AppRoutes.vehicleSelectFor(m.id)),
          child: Text(m.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        );
      },
    );
  }
}

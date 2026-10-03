import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/state_views.dart';
import '../product_list_controller.dart';
import 'product_card.dart';
import 'product_rail.dart';

/// Infinite-scrolling product grid bound to a [ProductListController].
class PagedProductGrid extends StatelessWidget {
  const PagedProductGrid({super.key, required this.controller, this.header, this.emptyMessage});

  final ProductListController controller;
  final Widget? header;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final c = controller;
        if (c.error != null && c.items.isEmpty) {
          return MessageView.error(c.error!, onRetry: c.refresh);
        }
        if (!c.isLoading && c.items.isEmpty) {
          return MessageView(
            icon: Icons.search_off_rounded,
            title: 'No products found',
            message: emptyMessage ?? 'Try a different keyword or browse categories.',
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.pixels > n.metrics.maxScrollExtent - 600) c.loadMore();
            return false;
          },
          child: RefreshIndicator(
            onRefresh: c.refresh,
            child: CustomScrollView(
              slivers: [
                if (header != null) SliverToBoxAdapter(child: header),
                if (c.total != null)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, AppSpacing.sm, AppSpacing.gutter, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        '${c.total} products',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  sliver: SliverGrid.builder(
                    gridDelegate: productGridDelegate(),
                    itemCount: c.isInitialLoading ? 6 : c.items.length,
                    itemBuilder: (_, i) =>
                        c.isInitialLoading ? const ProductCardSkeleton() : ProductCard(product: c.items[i]),
                  ),
                ),
                if (c.isLoading && c.items.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(padding: EdgeInsets.only(bottom: AppSpacing.xl), child: LoadingView()),
                  ),
                if (c.error != null && c.items.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: TextButton(onPressed: c.loadMore, child: const Text('Couldn’t load more · Retry')),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/search_field_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../catalog/presentation/widgets/product_card.dart';
import '../../../catalog/presentation/widgets/product_rail.dart';
import '../../../wishlist/presentation/wishlist_controller.dart';
import '../home_controller.dart';
import '../widgets/combo_deal_card.dart';
import '../widgets/department_strip.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/tabbed_product_rail.dart';
import '../widgets/vehicle_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeController>().ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();
    const gap = SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: home.load,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _Header()),
              const SliverToBoxAdapter(
                child: Padding(padding: AppSpacing.page, child: VehicleBar()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              const SliverToBoxAdapter(child: PromoCarousel()),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
              if (!(home.departments.hasError && !home.departments.hasData))
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: 'Shop by category', onAction: () => context.go(AppRoutes.shop)),
                      AppSpacing.gapMd,
                      DepartmentStrip(
                        departments: home.departments.data ?? const [],
                        loading: !home.departments.hasData,
                      ),
                    ],
                  ),
                ),
              if (!(home.departments.hasError && !home.departments.hasData)) gap,
              if (_visible(home.highlights.hasData, home.highlights.hasError, home.highlights.data?.isEmpty)) ...[
                SliverToBoxAdapter(
                  child: TabbedProductRail(
                    title: 'This week’s highlights',
                    groups: home.highlights.data ?? const {},
                    loading: !home.highlights.hasData,
                  ),
                ),
                gap,
              ],
              if (_visible(home.hotDeals.hasData, home.hotDeals.hasError, home.hotDeals.data?.isEmpty)) ...[
                const SliverToBoxAdapter(
                  child: SectionHeader(title: 'Hot deals', subtitle: 'Limited-time prices'),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                SliverPadding(
                  padding: AppSpacing.page,
                  sliver: SliverGrid.builder(
                    gridDelegate: productGridDelegate(),
                    itemCount: home.hotDeals.hasData ? home.hotDeals.data!.take(4).length : 4,
                    itemBuilder: (_, i) => home.hotDeals.hasData
                        ? ProductCard(product: home.hotDeals.data![i])
                        : const ProductCardSkeleton(),
                  ),
                ),
                gap,
              ],
              if (home.comboDeals.hasData && home.comboDeals.data!.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Combo deals',
                    subtitle: 'Head unit + add-ons, bundled',
                    onAction: () => context.push(AppRoutes.productList(title: 'Combo deals', query: 'Combo')),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: ComboDealCard.height,
                    child: ListView.separated(
                      padding: AppSpacing.page,
                      scrollDirection: Axis.horizontal,
                      itemCount: home.comboDeals.data!.length,
                      separatorBuilder: (_, _) => AppSpacing.gapMd,
                      itemBuilder: (_, i) => ComboDealCard(deal: home.comboDeals.data![i]),
                    ),
                  ),
                ),
                gap,
              ],
              if (_visible(home.audio.hasData, home.audio.hasError, home.audio.data?.isEmpty)) ...[
                SliverToBoxAdapter(
                  child: TabbedProductRail(
                    title: 'Car audio',
                    subtitle: 'Amps, subs and speakers',
                    groups: home.audio.data ?? const {},
                    loading: !home.audio.hasData,
                  ),
                ),
                gap,
              ],
              if (_visible(home.accessories.hasData, home.accessories.hasError, home.accessories.data?.isEmpty)) ...[
                SliverToBoxAdapter(
                  child: TabbedProductRail(
                    title: 'Install essentials',
                    subtitle: 'Fascias, wiring and power',
                    groups: home.accessories.data ?? const {},
                    loading: !home.accessories.hasData,
                  ),
                ),
                gap,
              ],
              const SliverToBoxAdapter(child: _TrustStrip()),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
            ],
          ),
        ),
      ),
    );
  }

  /// Hide a section if it failed with nothing cached, or loaded empty.
  bool _visible(bool hasData, bool hasError, bool? isEmpty) {
    if (hasError && !hasData) return false;
    if (hasData && (isEmpty ?? true)) return false;
    return true;
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wishlistCount = context.select<WishlistController, int>((w) => w.count);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.ink, borderRadius: AppRadius.small),
                child: const Icon(Icons.graphic_eq_rounded, color: AppColors.primaryBright, size: 22),
              ),
              AppSpacing.gapMd,
              Expanded(
                child: Text(
                  'KAYHAN AUDIO',
                  style: theme.textTheme.titleMedium?.copyWith(letterSpacing: 2, fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Wishlist',
                onPressed: () => context.push(AppRoutes.wishlist),
                icon: Badge(
                  isLabelVisible: wishlistCount > 0,
                  label: Text('$wishlistCount'),
                  child: const Icon(Icons.favorite_border_rounded),
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: SearchFieldButton(onTap: () => context.push(AppRoutes.search)),
          ),
        ],
      ),
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget item(IconData icon, String title, String body) => Expanded(
          child: Column(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              AppSpacing.gapSm,
              Text(title, textAlign: TextAlign.center, style: theme.textTheme.labelLarge),
              Text(
                body,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
    return Padding(
      padding: AppSpacing.page,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item(Icons.local_shipping_outlined, 'AU shipping', 'Australia-wide'),
              item(Icons.verified_outlined, 'Vehicle-specific', 'Made to fit'),
              item(Icons.support_agent_outlined, 'Expert help', 'Install support'),
            ],
          ),
        ),
      ),
    );
  }
}

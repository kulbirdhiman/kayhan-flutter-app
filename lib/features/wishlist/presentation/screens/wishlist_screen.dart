import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../catalog/presentation/widgets/product_card.dart';
import '../../../catalog/presentation/widgets/product_rail.dart';
import '../wishlist_controller.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistController>();
    return Scaffold(
      appBar: AppBar(title: Text(wishlist.count == 0 ? 'Wishlist' : 'Wishlist (${wishlist.count})')),
      body: wishlist.count == 0
          ? MessageView(
              icon: Icons.favorite_border_rounded,
              title: 'No saved items yet',
              message: 'Tap the heart on any product to save it for later.',
              actionLabel: 'Browse products',
              onAction: () => context.go(AppRoutes.shop),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              gridDelegate: productGridDelegate(),
              itemCount: wishlist.items.length,
              itemBuilder: (_, i) => ProductCard(product: wishlist.items[i]),
            ),
    );
  }
}

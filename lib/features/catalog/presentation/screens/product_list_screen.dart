import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../data/catalog_repository.dart';
import '../product_list_controller.dart';
import '../widgets/paged_product_grid.dart';

/// Product listing for a department, category, vehicle or search term.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key, required this.title, this.query});

  final String title;
  final String? query;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductListController _controller =
      ProductListController(context.read<CatalogRepository>(), query: widget.query)..loadMore();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(AppRoutes.search),
          ),
        ],
      ),
      body: PagedProductGrid(controller: _controller),
    );
  }
}

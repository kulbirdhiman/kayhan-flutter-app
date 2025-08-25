import 'package:flutter/material.dart';
import 'package:kayhan_app/services/product_service.dart';
import 'package:kayhan_app/widgets/products/ProductCard.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  final int limit = 10;
  List<dynamic> products = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchProducts();

    // Infinite scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          !isLoading) {
        fetchMoreProducts();
      }
    });
  }

  Future<void> fetchProducts({bool reset = true}) async {
    if (reset) {
      setState(() {
        isLoading = true;
        currentPage = 1;
        products.clear();
      });
    }

    try {
      final response = await ProductService.fetchProducts(
        page: currentPage,
        limit: limit,
        search: searchQuery,
      );

      final result = response.data["data"]?["result"] ?? [];

      setState(() {
        products.addAll(result);
        isLoading = false;
        isLoadingMore = false;
      });
    } catch (e) {
      print("❌ Error fetching products: $e");
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  Future<void> fetchMoreProducts() async {
    setState(() {
      isLoadingMore = true;
      currentPage++;
    });
    await fetchProducts(reset: false);
  }

  void onSearch() {
    setState(() {
      searchQuery = _searchController.text.trim();
    });
    fetchProducts(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Search")),
      body: Column(
        children: [
          // 🔎 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search products...",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.search), onPressed: onSearch),
              ],
            ),
          ),

          // 📦 Products Grid
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Center(child: Text("No products found"))
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 🔹 2 cards per row
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.75, // 🔹 control card height
                        ),
                        itemCount: products.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= products.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final product = products[index];
                          final name = product["name"] ?? "Unnamed";
                          final price = product["price"]?.toString() ?? "N/A";
                          final image =
                              (product["images"] != null &&
                                      product["images"].isNotEmpty)
                                  ? "https://d198m4c88a0fux.cloudfront.net/${product["images"][0]["image"]}"
                                  : "https://via.placeholder.com/150";

                          return ProductCard(
                            title: name,
                            price: "₹$price",
                            image: image,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

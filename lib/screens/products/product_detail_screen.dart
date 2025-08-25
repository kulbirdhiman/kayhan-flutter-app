import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dio/dio.dart';
import "../../services/product_service.dart";

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentIndex = 0;
  bool _loading = true;
  Map<String, dynamic>? product;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    try {
      final response = await ProductService.fetchProductByID(widget.productId);
      final data = response.data["data"]["result"]; // ✅ your structure
      setState(() {
        product = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load product: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }

    /// Build image URLs
    final List<String> images = (product?["images"] as List<dynamic>?)
            ?.map((e) => "https://d198m4c88a0fux.cloudfront.net/${e["image"]}") // ✅ prepend base URL
            .toList() ??
        ["https://via.placeholder.com/400x300.png?text=No+Image"];

    final String name = product?["name"] ?? "Unknown Product";
    final double price = (product?["regular_price"] ?? 0).toDouble();
    final String? description = product?["seo_description"] ?? product?["description"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          /// 🔹 Image Slider
          CarouselSlider(
            options: CarouselOptions(
              height: 300,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
            items: images.map((image) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, _, __) =>
                      const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                ),
              );
            }).toList(),
          ),

          /// 🔹 Slider Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Colors.purple
                      : Colors.grey.shade400,
                ),
              );
            }).toList(),
          ),

          /// 🔹 Product Info
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹$price",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description ?? "No description available.",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// 🔹 Sticky Bottom Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added to Cart")),
                  );
                },
                child: const Text("Add to Cart"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // ✅ Navigate to checkout page or buy now logic
                },
                child: const Text("Buy Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

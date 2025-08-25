import 'package:flutter/material.dart';
import 'package:kayhan_app/widgets/products/ProductCard.dart';
import 'package:kayhan_app/services/home_service.dart'; 
import 'package:dio/dio.dart';

class HighlightsTabSection extends StatelessWidget {
  const HighlightsTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: Text(
              "This Week's Highlights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          /// Tabs
          TabBar(
            isScrollable: false,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            tabs: const [
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                  ), // 👈 padding on X-axis
                  child: Text("Android stereo's"),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Linux headunit's"),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Carplay Module's"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Tab Views
          SizedBox(
            height: 570,
            child: TabBarView(
              children: [
                _buildProductsFromApi("android"), // category
                _buildProductsFromApi("linux"),
                _buildProductsFromApi("car_play"),
              ],
            ),
          ),

          /// See All Button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "See All",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper that fetches products from API
  static Widget _buildProductsFromApi(String category) {
    return FutureBuilder<Response>(
      future: HomeService.highlights(), // API call
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("No Data"));
        }

        // ✅ Get API response safely
        final response = snapshot.data!;
        final result = response.data?["data"]?["result"];

        // ✅ Check if category exists
        if (result == null || result[category] == null) {
          return const Center(child: Text("No products found"));
        }

        // ✅ Products are inside `data` array
        final List products = result[category]["data"] ?? [];

        if (products.isEmpty) {
          return const Center(child: Text("No products available"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final item = products[index];

            // ✅ Build CloudFront image URL
            final String? imageUrl =
                (item["images"] != null && item["images"].isNotEmpty)
                ? "https://d198m4c88a0fux.cloudfront.net/${item["images"][0]["image"]}"
                : null;

            return ProductCard(
              title: item["title"] ?? "No title",
              price: item["regular_price"]?.toString() ?? "",
              image: imageUrl!,
            );
          },
        );
      },
    );
  }
}

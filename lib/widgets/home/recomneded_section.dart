import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kayhan_app/widgets/products/ProductCard.dart';
import 'package:kayhan_app/services/home_service.dart';

class RecomnededSection extends StatelessWidget {
  const RecomnededSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recommended Products",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// API call using FutureBuilder
          FutureBuilder<Response>(
            future: HomeService.recomended(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData) {
                return const Text("No products found.");
              }

              // ✅ Extract safely
              final response = snapshot.data!;
              final result = response.data?["data"]?["result"];

              if (result == null) {
                return const Text("No products found.");
              }

              // ✅ Products array
              final List products = response.data?["data"]?["result"];

              if (products.isEmpty) {
                return const Text("No products available.");
              }

              return SizedBox(
                height: 260, // adjust based on your ProductCard height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];

                    // ✅ Handle CloudFront image safely
                    final String imageUrl =
                        (item["images"] != null && item["images"].isNotEmpty)
                        ? "https://d198m4c88a0fux.cloudfront.net/${item["images"][0]["image"]}"
                        : "https://via.placeholder.com/150";

                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                      ), // spacing between cards
                      child: SizedBox(
                        width: 160, // fix width for each card
                        child: ProductCard(
                          title: item["title"] ?? "No Title",
                          price: item["regular_price"]?.toString() ?? "",
                          image: imageUrl,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

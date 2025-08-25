import 'package:flutter/material.dart';

class CategoreySection extends StatelessWidget {
  const CategoreySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"icon": "https://caraudioexpert.com.au/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fheadunits.76893f10.webp&w=96&q=75", "title": "Head Unit"},
      {"icon": "https://caraudioexpert.com.au/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fspeakers.47d3a302.webp&w=96&q=75", "title": "Audio equipments"},
      {"icon": "https://caraudioexpert.com.au/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsterring-wheel.d6098b7f.webp&w=96&q=75", "title": "Steering Wheel's"},
      {"icon": "https://caraudioexpert.com.au/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fbattery.5073e8d2.webp&w=96&q=75", "title": "Frames & Fascias"},
        {"icon": "https://caraudioexpert.com.au/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Ffa.02e81e40.webp&w=96&q=75", "title": "Frames & Fascias"},
      {"icon": "https://caraudioexpert.com.au/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fabc.7195ff7b.png&w=96&q=75", "title": "Accessories"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Horizontal Scrollable Categories
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final item = categories[index];
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade200,
                      child: Image.network(item["icon"]!)
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["title"]!,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          /// This Week's Highlights
        ],
      ),
    );
  }
}

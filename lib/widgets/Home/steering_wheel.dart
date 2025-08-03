import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SteeringWheelSection extends StatelessWidget {
  const SteeringWheelSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1741343775404_1.jpg&w=1080&q=75',
      'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1741348677736_1.jpg&w=1080&q=75',
      'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1741348685966_3.jpg&w=1080&q=75',
      "https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1741348699725_4.jpg&w=1080&q=75"
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              "Steering-Wheel",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 16),
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlay: true,
            ),
            items: imageUrls.map((url) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Chip(
              label: Text(
                "Custom Steering Wheel's",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.purple,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Experience superior grip and comfort with our high-quality steering wheels. Designed for performance and style.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select Make:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            hint: const Text("Choose a Make"),
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'audi', child: Text("Audi")),
              DropdownMenuItem(value: 'bmw', child: Text("BMW")),
              DropdownMenuItem(value: 'mercedes', child: Text("Mercedes")),
            ],
            onChanged: (value) {},
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              // Navigate to explore page
            },
            child: const Text(
              "Explore More",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

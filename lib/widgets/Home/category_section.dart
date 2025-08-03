import 'package:flutter/material.dart';
import '../category_item.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'image': 'assets/headunit.png', 'label': 'Head Unit'},
      {'image': 'assets/head_unit_linux.png', 'label': 'Linux Head Unit'},
      {'image': 'assets/steering_wheel_box.png', 'label': 'Steering Wheel'},
      {'image': 'assets/facia.png', 'label': 'Frames & Fascias'},
      {'image': 'assets/headunit.png', 'label': 'Subwoofers Box'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(fontSize: 14, color: Colors.purple),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryItem(
                imagePath: category['image']!,
                label: category['label']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

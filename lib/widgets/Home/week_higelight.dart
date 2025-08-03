import 'package:flutter/material.dart';
import 'package:kayhan_app/widgets/global/ProductTabSelector.dart';
import '../cards/product_card.dart';

class WeekHigelight extends StatefulWidget {
  const WeekHigelight({super.key});

  @override
  State<WeekHigelight> createState() => _WeekHigelight();
}

class _WeekHigelight extends State<WeekHigelight> {
  int selectedTabIndex = 0;

  final List<String> tabTitles = [
    "Android stereo's",
    "Linux headunit's",
    "Carplay Module's",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // Prevent bottom overflow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "This Week's Highlights",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ProductTabSelector(
            tabs: tabTitles,
            onTabChanged: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // padding: const EdgeInsets.only(bottom: 8), // Extra bottom padding
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.57,
                ),
                itemBuilder: (context, index) {
                  return const ProductCard();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

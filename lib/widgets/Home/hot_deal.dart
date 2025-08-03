import 'package:flutter/material.dart';
import 'package:kayhan_app/widgets/cards/product_card.dart';

class HotDeal extends StatelessWidget {
  const HotDeal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hot Deal's",
            style: TextStyle(
              color: Color.fromARGB(255, 97, 96, 94),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.5,
            ),
            itemBuilder: (context, index) {
              return const ProductCard();
            },
          ),
        ],
      ),
    );
  }
}

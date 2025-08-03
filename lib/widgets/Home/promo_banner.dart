import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView(
        children: const [
          PromoSlide(
            imagePath: 'assets/banner1.png',
            title: '',
            description:
                '',
          ),
          PromoSlide(
            imagePath: 'assets/banner1.png',
            title: 'ANDROID\nHEAD UNITS',
            description:
                'Upgrade your ride with seamless navigation\nand powerful connectivity options.',
          ),
        ],
      ),
    );
  }
}

class PromoSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const PromoSlide({
    required this.imagePath,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        // Overlay
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // gradient: LinearGradient(
            //   colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            //   begin: Alignment.bottomLeft,
            //   end: Alignment.topRight,
            // ),
          ),
        ),

        // Text
        Positioned(
          left: 16,
          top: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

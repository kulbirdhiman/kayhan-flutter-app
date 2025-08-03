import 'package:flutter/material.dart'
    hide SearchBar; // hides Flutter's SearchBar
import 'package:kayhan_app/widgets/Home/combo_deal.dart';
import 'package:kayhan_app/widgets/Home/hot_deal.dart';
import 'package:kayhan_app/widgets/Home/steering_wheel.dart';
import 'package:kayhan_app/widgets/Home/week_higelight.dart';
import '../widgets/address_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/Home/promo_banner.dart';
import '../widgets/Home/category_section.dart';
import '../widgets/sections/recommended_product.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: const [
              SizedBox(height: 10),
              AddressBar(),
              SizedBox(height: 10),
              SearchBar(),
              SizedBox(height: 20),
              PromoBanner(),
              CategorySection(),
              SizedBox(height: 20),
              WeekHigelight(),
              SizedBox(height: 20),
              RecommendedProductSection(),
              HotDeal(),
              ComboDeal(),
              SteeringWheelSection()
            ],
          ),
        ),
      ),
    );
  }
}

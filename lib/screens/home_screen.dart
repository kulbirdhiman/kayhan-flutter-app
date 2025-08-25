import 'package:flutter/material.dart';
import 'package:kayhan_app/widgets/home/HighlightsTabSection.dart';
import 'package:kayhan_app/widgets/home/categorey_section.dart';
import 'package:kayhan_app/widgets/home/combo_deals.dart';
import 'package:kayhan_app/widgets/home/hot_deals_section.dart';
import 'package:kayhan_app/widgets/home/recomneded_section.dart';
import 'package:kayhan_app/widgets/home/streering_wheel.dart';
import '../widgets/home/custom_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> demoImages = [
      "https://kayhanaudio.com.au/_next/image?url=%2Fimages%2FAmp-banner.png&w=1920&q=100",
      "https://picsum.photos/id/1015/600/300",
      "https://picsum.photos/id/1019/600/300",
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // ✅ now everything scrolls
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSlider(images: demoImages),
              const CategoreySection(),
              const HighlightsTabSection(),
              const RecomnededSection(),
              const HotDealsSection(),
              const ComboDealsSection(),
              const SteeringWheelSection()
            ],
          ),
        ),
      ),
    );
  }
}

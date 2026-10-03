import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class _Promo {
  const _Promo(this.eyebrow, this.title, this.cta, this.icon, this.colors, this.route);

  final String eyebrow;
  final String title;
  final String cta;
  final IconData icon;
  final List<Color> colors;
  final String route;
}

/// Auto-advancing brand banners, drawn natively (no image assets needed).
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  static final _promos = [
    _Promo(
      'WIRELESS CARPLAY & ANDROID AUTO',
      'Upgrade your factory screen',
      'Shop CarPlay',
      Icons.phone_iphone_rounded,
      const [AppColors.ink, Color(0xFF0F3B5F)],
      AppRoutes.productList(title: 'CarPlay modules', query: 'CarPlay'),
    ),
    _Promo(
      'COMBO DEALS',
      'Stereo + camera bundles',
      'View bundles',
      Icons.local_offer_rounded,
      const [Color(0xFF4A0D1E), Color(0xFF9F1239)],
      AppRoutes.productList(title: 'Combo deals', query: 'Combo'),
    ),
    _Promo(
      'CAR AUDIO',
      'Amplifiers, subs & speakers',
      'Shop audio',
      Icons.speaker_rounded,
      const [Color(0xFF1E1B4B), Color(0xFF4338CA)],
      AppRoutes.productList(title: 'Car audio', query: 'Audio'),
    ),
  ];

  final _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_controller.hasClients) return;
      _controller.animateToPage(
        (_index + 1) % _promos.length,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _controller,
            itemCount: _promos.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) {
              final p = _promos[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Material(
                  borderRadius: AppRadius.large,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.push(p.route),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: p.colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -18,
                            bottom: -18,
                            child: Icon(p.icon, size: 150, color: Colors.white.withValues(alpha: 0.09)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.eyebrow,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.primaryBright,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                AppSpacing.gapSm,
                                Text(
                                  p.title,
                                  maxLines: 2,
                                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, height: 1.15),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      p.cta,
                                      style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                                    ),
                                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AppSpacing.gapSm,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _promos.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _index ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _index ? theme.colorScheme.primary : theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

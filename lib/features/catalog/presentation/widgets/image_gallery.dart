import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Swipeable product gallery with page dots and thumbnail strip.
class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key, required this.images});

  final List<String> images;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int i) =>
      _controller.animateToPage(i, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final images = widget.images.isEmpty ? <String?>[null] : widget.images;

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: AppNetworkImage(images[i]),
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    right: AppSpacing.lg,
                    bottom: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_index + 1} / ${images.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (images.length > 1)
          SizedBox(
            height: 76,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter, vertical: AppSpacing.sm),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, _) => AppSpacing.gapSm,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => _goTo(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 60,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.small,
                    border: Border.all(
                      color: i == _index ? scheme.primary : scheme.outline,
                      width: i == _index ? 2 : 1,
                    ),
                  ),
                  child: AppNetworkImage(images[i]),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

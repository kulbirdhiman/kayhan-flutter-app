import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Cached network image with consistent placeholder and error states.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.borderRadius,
    this.background,
  });

  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: width,
      height: height,
      color: background ?? scheme.surfaceContainer,
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, color: scheme.onSurfaceVariant.withValues(alpha: 0.5)),
    );

    final image = (url == null || url!.isEmpty)
        ? placeholder
        : CachedNetworkImage(
            imageUrl: url!,
            fit: fit,
            width: width,
            height: height,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (_, _) => Container(
              width: width,
              height: height,
              color: background ?? scheme.surfaceContainer,
            ),
            errorWidget: (_, _, _) => placeholder,
          );

    final framed = Container(
      color: background ?? Colors.white,
      width: width,
      height: height,
      child: image,
    );

    return borderRadius == null ? framed : ClipRRect(borderRadius: borderRadius!, child: framed);
  }
}

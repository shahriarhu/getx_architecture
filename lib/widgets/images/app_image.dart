import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_spacing.dart';

/// One image widget for every source.
///
/// [AppImage.asset] picks the SVG or raster loader from the file extension, and
/// [AppImage.network] adds disk caching plus placeholder/error fallbacks — so
/// no screen has to remember which package to reach for.
class AppImage extends StatelessWidget {
  const AppImage.asset(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.radius = 0,
    this.placeholder,
    this.errorWidget,
  }) : _isNetwork = false;

  const AppImage.network(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.radius = 0,
    this.placeholder,
    this.errorWidget,
  }) : _isNetwork = true;

  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool _isNetwork;

  bool get _isSvg => path?.toLowerCase().endsWith('.svg') ?? false;

  @override
  Widget build(BuildContext context) {
    final source = path;
    if (source == null || source.isEmpty) return _fallback(context);

    final image = _isNetwork ? _network(source) : _asset(source);

    return radius == 0
        ? image
        : ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
  }

  Widget _asset(String source) {
    if (_isSvg) {
      return SvgPicture.asset(
        source,
        width: width,
        height: height,
        fit: fit,
        colorFilter:
            color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
        placeholderBuilder: (_) => placeholder ?? _sized(const SizedBox()),
      );
    }

    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, _, _) => _fallback(context),
    );
  }

  Widget _network(String source) {
    if (_isSvg) {
      return SvgPicture.network(
        source,
        width: width,
        height: height,
        fit: fit,
        colorFilter:
            color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      );
    }

    return CachedNetworkImage(
      imageUrl: source,
      width: width,
      height: height,
      fit: fit,
      color: color,
      fadeInDuration: AppDurations.fast,
      placeholder: (_, _) => placeholder ?? _sized(const _ImageShimmer()),
      errorWidget: (context, _, _) => _fallback(context),
    );
  }

  Widget _fallback(BuildContext context) =>
      errorWidget ??
      _sized(
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Icon(
            Icons.image_not_supported_outlined,
            size: AppSizes.iconLg,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );

  Widget _sized(Widget child) =>
      SizedBox(width: width, height: height, child: child);
}

class _ImageShimmer extends StatelessWidget {
  const _ImageShimmer();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surfaceContainer,
  );
}

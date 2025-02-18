import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double radius;
  final Widget? errorWidget;
  final IconData? errorIconData;
  final Widget? loadingWidget;
  final BoxFit? fit;
  final Color? color;
  final double? padding;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.radius = 0.0,
    this.errorWidget,
    this.errorIconData,
    this.loadingWidget,
    this.fit = BoxFit.cover,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl?.isEmpty ?? true) {
      return _buildErrorPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      height: height,
      width: width,
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      imageBuilder: (context, imageProvider) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: EdgeInsets.all(padding ?? 0),
            decoration: BoxDecoration(color: color ?? Colors.grey[200]),
            child: Image(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) => _buildLoadingIndicator(),
      errorWidget: (context, url, error) => _buildErrorPlaceholder(),
    );
  }

  Widget _buildErrorPlaceholder() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Icon(errorIconData ?? Icons.image_not_supported_outlined),
        );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: loadingWidget ?? const CircularProgressIndicator(),
    );
  }
}

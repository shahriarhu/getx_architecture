import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetSvgWidget extends StatelessWidget {
  const AssetSvgWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.color,
    this.padding = 0,
  });

  final String url;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final Color? color;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SvgPicture.asset(
        height: height,
        width: width,
        url,
        fit: fit,
        color: color,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AssetImageWidget extends StatelessWidget {
  const AssetImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.color,
    this.padding = 0,
  });

  final String imageUrl;
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
      child: Container(
        color: color,
        padding: EdgeInsets.all(padding),
        child: Image.asset(
          height: height,
          width: width,
          imageUrl,
          fit: fit,
        ),
      ),
    );
  }
}

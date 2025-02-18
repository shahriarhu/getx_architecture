import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final EdgeInsets? margin;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerBox({
    super.key,
    this.height,
    this.width,
    this.radius,
    this.margin,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDarkMode ? shimmerBaseDark : shimmerBaseLight),
      highlightColor: highlightColor ?? (isDarkMode ? shimmerHighlightDark : shimmerHighlightLight),
      enabled: true,
      child: Container(
        height: height ?? 16,
        width: width ?? 80,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          color: baseColor?.withOpacity(0.3) ?? secondaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(radius ?? 6),
        ),
      ),
    );
  }
}

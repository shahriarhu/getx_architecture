import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/extensions/context_extensions.dart';
import '../../theme/app_spacing.dart';

/// Skeleton placeholder. Prefer a shimmer that mirrors the real layout over a
/// bare spinner — it reduces perceived load time and avoids layout jumps.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.radius = AppRadius.sm,
    this.margin,
  });

  /// A full-width line, typically used for text placeholders.
  const ShimmerBox.line({
    super.key,
    this.width = double.infinity,
    this.height = 12,
    this.radius = AppRadius.xs,
    this.margin,
  });

  final double? width;
  final double height;
  final double radius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semantic;

    return Shimmer.fromColors(
      baseColor: semantic.shimmerBase,
      highlightColor: semantic.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: semantic.shimmerBase,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Wraps any subtree in the shimmer effect — use for skeleton screens built
/// from real widgets.
class ShimmerGroup extends StatelessWidget {
  const ShimmerGroup({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: context.semantic.shimmerBase,
    highlightColor: context.semantic.shimmerHighlight,
    child: child,
  );
}

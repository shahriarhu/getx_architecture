import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/loading/shimmer_box.dart';
import '../data/article.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article, this.onTap});

  final Article article;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMedium(article.title, maxLines: 2),
              const SizedBox(height: AppSpacing.sm),
              AppText.bodySmall(
                article.body,
                maxLines: 3,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton shown while the list loads — mirrors [ArticleTile]'s shape so the
/// layout does not jump when real data arrives.
class ArticleTileSkeleton extends StatelessWidget {
  const ArticleTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(height: 18, width: 220),
          const SizedBox(height: AppSpacing.md),
          const ShimmerBox.line(),
          const SizedBox(height: AppSpacing.sm),
          const ShimmerBox.line(),
          const SizedBox(height: AppSpacing.sm),
          ShimmerBox.line(width: MediaQuery.sizeOf(context).width * 0.4),
        ],
      ),
    ),
  );
}

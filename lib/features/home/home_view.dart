import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/extensions/num_extensions.dart';
import '../../l10n/translation_keys.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_text.dart';
import '../../widgets/inputs/app_text_field.dart';
import '../../widgets/layouts/app_scaffold.dart';
import '../../widgets/states/state_view.dart';
import '../../widgets/states/status_views.dart';
import 'data/article.dart';
import 'home_controller.dart';
import 'widgets/article_tile.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padded: false,
      appBar: AppBar(
        titleSpacing: AppSpacing.page,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.titleLarge(LocaleKeys.articles.tr),
            Obx(
              () => AppText.bodySmall(
                controller.user?.name ?? LocaleKeys.home.tr,
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed<void>(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: LocaleKeys.settings.tr,
          ),
          AppSpacing.sm.horizontalSpace,
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.sm,
              AppSpacing.page,
              AppSpacing.md,
            ),
            child: AppTextField(
              hint: LocaleKeys.search.tr,
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
              onChanged: controller.onSearchChanged,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshArticles,
              child: Obx(
                () => StateView<List<Article>>(
                  state: controller.articles.value,
                  onRetry: controller.load,
                  emptyMessage: LocaleKeys.articlesEmpty.tr,
                  loadingBuilder: (_) => const _LoadingList(),
                  builder: (articles) {
                    final visible = controller.visible(articles);
                    if (visible.isEmpty) {
                      return EmptyView(onRetry: controller.load);
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        0,
                        AppSpacing.page,
                        AppSpacing.xl,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: visible.length,
                      separatorBuilder:
                          (_, _) => const SizedBox(height: AppSpacing.md),
                      itemBuilder:
                          (_, index) => ArticleTile(article: visible[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
    itemCount: 6,
    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
    itemBuilder: (_, _) => const ArticleTileSkeleton(),
  );
}

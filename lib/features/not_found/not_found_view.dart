import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../l10n/translation_keys.dart';
import '../../widgets/layouts/app_scaffold.dart';
import '../../widgets/states/status_views.dart';

/// Fallback for unregistered routes and broken deep links.
class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
    body: MessageView(
      icon: Icons.explore_off_outlined,
      title: LocaleKeys.errorRouteNotFound.tr,
      actionLabel: LocaleKeys.home.tr,
      onAction: () => Get.offAllNamed<void>(AppRoutes.home),
    ),
  );
}

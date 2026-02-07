import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';
import 'package:getx_architecture/app/ui/widgets/texts/bodys.dart';
import 'package:getx_architecture/app/ui/widgets/texts/titles.dart';
import 'package:getx_architecture/app/utils/ui_spacing.dart';

List<BoxShadow> getToastBoxShadow = [
  const BoxShadow(
    color: Color(0x251C0707),
    blurRadius: 24,
    offset: Offset(0, 8),
  ),
];

EdgeInsets getToastPadding = EdgeInsets.symmetric(vertical: UISpacing.small, horizontal: UISpacing.medium);

void showError(String? message, {String? title, SnackPosition position = SnackPosition.TOP}) {
  Get.rawSnackbar(
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.error,
          color: errorColor,
          size: 20,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                TitleSmall(title.tr),
                const SizedBox(height: 4),
              ],
              BodySmall(
                message?.tr,
              )
            ],
          ),
        ),
      ],
    ),
    borderRadius: 14,
    backgroundColor: Get.theme.scaffoldBackgroundColor,
    snackPosition: position,
    duration: const Duration(seconds: 4),
    margin: EdgeInsets.all(UISpacing.small),
    boxShadows: getToastBoxShadow,
    padding: getToastPadding,
  );
}

void showSuccess(String? message, {String? title, SnackPosition position = SnackPosition.TOP}) {
  Get.rawSnackbar(
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          color: successColor,
          size: 20,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                TitleSmall(title.tr),
                const SizedBox(height: 4),
              ],
              BodySmall(message?.tr)
            ],
          ),
        ),
      ],
    ),
    borderRadius: 14,
    backgroundColor: Get.theme.scaffoldBackgroundColor,
    snackPosition: position,
    duration: const Duration(seconds: 4),
    margin: const EdgeInsets.all(20),
    boxShadows: getToastBoxShadow,
    padding: getToastPadding,
  );
}

void upcomingToast(
    {String title = "upcomingFeature",
    String message = "upcomingMessage",
    SnackPosition position = SnackPosition.BOTTOM}) {
  Get.snackbar(
    title.tr,
    message.tr,
    icon: const Icon(Icons.upcoming_outlined, color: Color(0xFF96C0FF)),
    backgroundColor: Get.theme.scaffoldBackgroundColor,
    snackPosition: position,
    duration: const Duration(seconds: 5),
    margin: EdgeInsets.all(UISpacing.small),
    boxShadows: [
      const BoxShadow(color: Color(0xFFE6F0FF), blurRadius: 15),
    ],
    padding: getToastPadding,
  );
}

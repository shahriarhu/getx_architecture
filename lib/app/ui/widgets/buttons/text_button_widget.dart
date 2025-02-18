import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/ui/widgets/texts/titles.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: TitleSmall(
        text: label,
        color: Get.theme.primaryColor,
      ),
    );
  }
}

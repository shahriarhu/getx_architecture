import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/widgets/texts/titles.dart';
import 'package:getx_architecture/app/utils/ui_helpers.dart';

class MainButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? prefix;
  final Widget? postfix;
  final bool loading;
  final bool? fullWidth;
  final MainAxisAlignment mainAxisAlignment;

  const MainButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.prefix,
    this.postfix,
    this.loading = false,
    this.fullWidth = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    const space = SizedBox(width: 20.0);
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: UIHelper.bigPadding()),
        child: Row(
          mainAxisSize: fullWidth == true ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            if (loading) ...[const CircularProgressIndicator(), space],
            if (prefix != null && loading != true) ...[prefix!, space],
            TitleMedium(text: label),
            if (postfix != null && loading != true) ...[space, postfix!],
          ],
        ),
      ),
    );
  }
}

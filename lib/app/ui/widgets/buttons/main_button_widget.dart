import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';

class MainButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? prefix;
  final Widget? postfix;
  final bool loading;
  final bool? fullWidth;
  final Color color;
  final MainAxisAlignment mainAxisAlignment;

  const MainButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.prefix,
    this.postfix,
    this.loading = false,
    this.fullWidth = true,
    this.color = primaryColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    const space = SizedBox(width: 20.0);
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisSize: fullWidth == true ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            if (loading) ...[
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
              space
            ],
            if (prefix != null && loading != true) ...[prefix!, space],
            Text(label),
            if (postfix != null && loading != true) ...[space, postfix!],
          ],
        ),
      ),
    );
  }
}

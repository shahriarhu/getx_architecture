import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';
import 'package:getx_architecture/app/ui/widgets/texts/bodys.dart';
import 'package:getx_architecture/app/ui/widgets/texts/titles.dart';
import 'package:getx_architecture/app/utils/ui_spacing.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.title,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.maxLines = 1,
    this.textInputType,
    this.controller,
    this.validator,
    this.isTopPadding = true,
    this.isLastField = false,
    this.isObscureText = false,
    this.isMandatory = false,
  });

  final String title;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final int maxLines;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isTopPadding;
  final bool isLastField;
  final bool isObscureText;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: isTopPadding ? UISpacing.medium : 0,
            bottom: UISpacing.small,
          ),
          child: isMandatory
              ? Row(
                  children: [
                    const TitleSmall(
                      text: '*',
                      color: errorColor,
                    ),
                    const SizedBox(width: 4),
                    TitleSmall(text: title),
                  ],
                )
              : BodyMedium(text: title),
        ),
        TextFormField(
          controller: controller,
          obscureText: isObscureText,
          validator: validator,
          keyboardType: textInputType,
          maxLines: maxLines,
          textInputAction: isLastField ? TextInputAction.done : TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(UISpacing.small),
              child: prefixIcon,
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.all(UISpacing.small),
              child: suffixIcon,
            ),
            suffixText: suffixText,
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}

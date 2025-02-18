import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';
import 'package:getx_architecture/app/ui/widgets/texts/bodys.dart';
import 'package:getx_architecture/app/ui/widgets/texts/titles.dart';

class DropdownButtonWidget<T> extends StatelessWidget {
  const DropdownButtonWidget({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(
          text: '${label.tr}:',
          color: secondaryColor,
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButton<T>(
            dropdownColor: theme.scaffoldBackgroundColor,
            underline: const SizedBox(),
            value: value,
            items: items,
            isExpanded: true,
            onChanged: onChanged,
            hint: BodyLarge(
              text: 'selectLabel'.trParams({'label': label.tr.toLowerCase()}),
            ),
            icon: const Icon(
              Icons.expand_more,
              color: secondaryColor,
            ),
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

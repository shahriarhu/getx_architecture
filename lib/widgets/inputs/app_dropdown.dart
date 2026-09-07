import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../app_text.dart';

/// Themed dropdown that matches [AppTextField]'s label and border treatment.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.label,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.validator,
  });

  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  /// How each item is rendered — keeps the widget free of model knowledge.
  final String Function(T item) itemLabel;

  final String? label;
  final String? hint;
  final bool isRequired;
  final bool enabled;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              AppText.labelLarge(label),
              if (isRequired) AppText.labelLarge(' *', color: colors.error),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: [
            for (final item in items)
              DropdownMenuItem<T>(
                value: item,
                child: AppText.bodyMedium(itemLabel(item), maxLines: 1),
              ),
          ],
          onChanged: enabled ? onChanged : null,
          validator: validator,
          isExpanded: true,
          borderRadius: BorderRadius.circular(AppRadius.md),
          dropdownColor: colors.surface,
          icon: const Icon(Icons.expand_more, size: AppSizes.iconLg),
          hint: hint == null ? null : AppText.bodyMedium(hint),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}

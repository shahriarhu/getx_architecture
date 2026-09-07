import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../l10n/translation_keys.dart';
import '../constants/app_constants.dart';

/// Reusable, composable form validators.
///
/// Each returns a `FormFieldValidator<String>` so it drops straight into
/// `TextFormField.validator`, and [compose] chains them in order.
abstract final class Validators {
  static final _email = RegExp(r'^[\w.!#$%&’*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$');
  static final _phone = RegExp(r'^\+?[0-9]{7,15}$');
  static final _hasLetter = RegExp('[A-Za-z]');
  static final _hasDigit = RegExp('[0-9]');

  /// Runs validators in order and returns the first failure.
  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) => (value) {
    for (final validate in validators) {
      final error = validate(value);
      if (error != null) return error;
    }
    return null;
  };

  static FormFieldValidator<String> required({String? message}) =>
      (value) =>
          (value == null || value.trim().isEmpty)
              ? (message ?? LocaleKeys.validationRequired.tr)
              : null;

  static FormFieldValidator<String> email({String? message}) => (value) {
    if (value == null || value.trim().isEmpty) return null;
    return _email.hasMatch(value.trim())
        ? null
        : (message ?? LocaleKeys.validationEmail.tr);
  };

  static FormFieldValidator<String> phone({String? message}) => (value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'[\s()-]'), '');
    return _phone.hasMatch(digits)
        ? null
        : (message ?? LocaleKeys.validationPhone.tr);
  };

  static FormFieldValidator<String> minLength(int length, {String? message}) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        return value.trim().length >= length
            ? null
            : (message ??
                LocaleKeys.validationMinLength.trParams({'min': '$length'}));
      };

  static FormFieldValidator<String> maxLength(int length, {String? message}) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        return value.trim().length <= length
            ? null
            : (message ??
                LocaleKeys.validationMaxLength.trParams({'max': '$length'}));
      };

  /// At least [AppConstants.minPasswordLength] characters, one letter and one
  /// digit. Tighten here once and every password field follows.
  static FormFieldValidator<String> password({String? message}) => (value) {
    if (value == null || value.isEmpty) return null;
    final strong =
        value.length >= AppConstants.minPasswordLength &&
        _hasLetter.hasMatch(value) &&
        _hasDigit.hasMatch(value);
    return strong ? null : (message ?? LocaleKeys.validationPassword.tr);
  };

  /// Confirms a value matches another field, read lazily so it sees the latest
  /// text at validation time.
  static FormFieldValidator<String> matches(
    String Function() other, {
    String? message,
  }) =>
      (value) =>
          value == other()
              ? null
              : (message ?? LocaleKeys.validationMismatch.tr);
}

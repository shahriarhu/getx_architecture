/// Null-safe string helpers.
///
/// Declared on `String?` on purpose — GetX already extends `String`, and
/// re-declaring names there would make call sites ambiguous.
extension NullableStringX on String? {
  String get orEmpty => this ?? '';

  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Returns [fallback] when blank — handy for `-` placeholders in the UI.
  String ifBlank(String fallback) => isNullOrBlank ? fallback : this!;

  /// Truncates with an ellipsis, never mid-whitespace.
  String truncate(int max, {String ellipsis = '…'}) {
    final value = orEmpty;
    if (value.length <= max) return value;
    return '${value.substring(0, max).trimRight()}$ellipsis';
  }

  /// `"md shahriar hossain"` → `"Md Shahriar Hossain"`.
  String get titleCase => orEmpty
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');

  /// Digits only — useful before sending a phone number to an API.
  String get digitsOnly => orEmpty.replaceAll(RegExp(r'[^0-9]'), '');
}

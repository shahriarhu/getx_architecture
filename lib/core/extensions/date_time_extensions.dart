import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../l10n/translation_keys.dart';

/// Canonical date/time patterns. Add new formats here rather than passing
/// pattern strings around.
abstract final class AppDateFormats {
  static const date = 'dd MMM yyyy';
  static const dateWithDay = 'EEE, dd MMM yyyy';
  static const time = 'hh:mm a';
  static const dateTime = 'dd MMM yyyy, hh:mm a';
  static const monthYear = 'MMMM yyyy';
  static const iso = 'yyyy-MM-dd';
}

extension DateTimeX on DateTime {
  /// Formats using the app's active locale, so Bangla dates render in Bangla.
  String format([String pattern = AppDateFormats.date]) =>
      DateFormat(pattern, Get.locale?.toString()).format(this);

  String get asDate => format();

  String get asTime => format(AppDateFormats.time);

  String get asDateTime => format(AppDateFormats.dateTime);

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  bool get isToday => _isSameDay(DateTime.now());

  bool get isYesterday =>
      _isSameDay(DateTime.now().subtract(const Duration(days: 1)));

  bool get isPast => isBefore(DateTime.now());

  bool get isFuture => isAfter(DateTime.now());

  /// "just now" / "5m ago" / "3d ago", falling back to a date past a week.
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return LocaleKeys.timeJustNow.tr;
    if (diff.inMinutes < 60) {
      return LocaleKeys.timeMinutesAgo.trParams({'n': '${diff.inMinutes}'});
    }
    if (diff.inHours < 24) {
      return LocaleKeys.timeHoursAgo.trParams({'n': '${diff.inHours}'});
    }
    if (diff.inDays < 7) {
      return LocaleKeys.timeDaysAgo.trParams({'n': '${diff.inDays}'});
    }
    return asDate;
  }

  bool _isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

extension NullableDateTimeX on DateTime? {
  /// Formats safely, returning [placeholder] instead of throwing on null.
  String formatOr(
    String placeholder, [
    String pattern = AppDateFormats.date,
  ]) => this == null ? placeholder : this!.format(pattern);
}

/// Parses a server date without throwing — returns null on anything unexpected.
DateTime? tryParseDate(Object? value) => switch (value) {
  final DateTime date => date,
  final String text => DateTime.tryParse(text),
  final num epoch => DateTime.fromMillisecondsSinceEpoch(epoch.toInt()),
  _ => null,
};

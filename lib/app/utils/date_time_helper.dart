import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  DateTimeHelper._();

  static String toStringDateFromDate({DateTime? date, String? format = 'EEE, dd MMM yyyy'}) {
    try {
      if (date == null || format == null || format.isEmpty) {
        return ' - ';
      }
      return DateFormat(format).format(date);
    } catch (e) {
      return ' - ';
    }
  }

  static String toStringTimeFromDate({DateTime? date}) {
    try {
      if (date == null) {
        return ' - ';
      }
      return DateFormat('hh:mm a').format(date); // Ensures leading zeros for hours.
    } catch (e) {
      return ' - ';
    }
  }

  static String toStringTimeFromTime({TimeOfDay? time}) {
    try {
      if (time == null) {
        return ' - ';
      }
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return ' - ';
    }
  }

  static String toStringTimeFromStringTime({String? time}) {
    try {
      if (time == null || time.isEmpty) {
        return ' - ';
      }

      final parsedTime = DateFormat('HH:mm:ss').parse(time);

      return DateFormat('hh:mm a').format(parsedTime);
    } catch (e) {
      return ' - ';
    }
  }

  static bool isDateRangeValid(DateTime? selectedStartDate, DateTime? selectedEndDate) {
    if (selectedStartDate == null || selectedEndDate == null) return false;
    return selectedEndDate.isAfter(selectedStartDate) || selectedEndDate.isAtSameMomentAs(selectedStartDate);
  }
}

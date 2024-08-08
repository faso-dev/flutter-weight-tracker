import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd(
      'fr_FR',
    ).format(date);
  }

  static String formatDateWithTime(DateTime date) {
    return DateFormat.yMMMd(
      'fr_FR',
    ).add_Hm().format(date);
  }

  static String formatDateForChart(DateTime date) {
    return DateFormat.MMMd(
      'fr_FR',
    ).format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat.yMMM(
      'fr_FR',
    ).format(date);
  }

  static String getWeekday(DateTime date) {
    return DateFormat.E(
      'fr_FR',
    ).format(date);
  }

  static String formatTimeOnly(DateTime date) {
    return DateFormat.Hm(
      'fr_FR',
    ).format(date);
  }
}

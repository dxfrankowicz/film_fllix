import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateUtils {
  static final DateFormat _monthFormat = new DateFormat("MMMM yyyy");
  static final DateFormat _dayFormat = new DateFormat("dd");
  static final DateFormat _firstDayFormat = new DateFormat("MMM dd");
  static final DateFormat _fullDayFormat = new DateFormat("EEE MMM dd, yyyy");
  static final DateFormat _apiDayFormat = new DateFormat("yyyy-MM-dd");

  static String formatMonth(DateTime d) => _monthFormat.format(d);
  static String formatDay(DateTime d) => _dayFormat.format(d);
  static String formatFirstDay(DateTime d) => _firstDayFormat.format(d);
  static String fullDayFormat(DateTime d) => _fullDayFormat.format(d);
  static String apiDayFormat(DateTime d) => _apiDayFormat.format(d);

  static List<DateTime> daysInMonthFromDateTime(DateTime month) {
    var first = firstDayOfMonth(month);
    var daysBefore = first.weekday;
    var firstToDisplay = first.subtract(new Duration(days: daysBefore));
    var last = DateUtils.lastDayOfMonth(month);

    var daysAfter = 7 - last.weekday;
    var lastToDisplay = last.add(new Duration(days: daysAfter));
    return daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  static bool isFirstDayOfMonth(DateTime day) {
    return isSameDay(firstDayOfMonth(day), day);
  }

  static bool isLastDayOfMonth(DateTime day) {
    return isSameDay(lastDayOfMonth(day), day);
  }

  static DateTime firstDayOfMonth(DateTime month) {
    return new DateTime(month.year, month.month);
  }

  static DateTime firstDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar works from Sunday - Monday
    var decreaseNum = day.weekday - 1;
    return day.subtract(new Duration(days: decreaseNum));
  }

  static DateTime lastDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar's Week starts on Sunday
    var increaseNum = day.weekday - 1;
    return day.add(new Duration(days: 7 - increaseNum));
  }

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  /// Returns a [DateTime] for each day the given range.
  ///
  /// [start] inclusive
  /// [end] exclusive
  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.add(new Duration(days: 1));
      var timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(new Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }

  /// Whether or not two times are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  static bool isSameWeek(DateTime a, DateTime b) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    a = new DateTime.utc(a.year, a.month, a.day);
    b = new DateTime.utc(b.year, b.month, b.day);

    var diff = a.toUtc().difference(b.toUtc()).inDays;
    if (diff.abs() >= 7) {
      return false;
    }

    var min = a.isBefore(b) ? a : b;
    var max = a.isBefore(b) ? b : a;
    var result = max.weekday - min.weekday >= 0;
    return result;
  }

  static DateTime previousMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return new DateTime(year, month);
  }

  static DateTime nextMonth(DateTime m) {
    var year = m.year;
    var month = m.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return new DateTime(year, month);
  }

  static DateTime previousWeek(DateTime w) {
    return w.subtract(new Duration(days: 7));
  }

  static DateTime nextWeek(DateTime w) {
    return w.add(new Duration(days: 7));
  }

  static String getDateWeekdayName(BuildContext context, DateTime d) {
    initializeDateFormatting("pl_PL");
    var formatter =
        new DateFormat('E', Localizations.localeOf(context).toString());
    return formatter.format(d);
  }

  static String formatTrainingDate(BuildContext context, DateTime d) {
    var locale = Localizations.localeOf(context).toString();
    initializeDateFormatting(locale);
    var formatter =
        new DateFormat('E, MMM dd', Localizations.localeOf(context).toString());
    return formatter.format(d);
  }

  static String formatDate(DateTime d) {
    var formatter = new DateFormat('dd.MM.yyyy');
    return formatter.format(d);
  }

  static String formatDateWithName(BuildContext context, DateTime d) {
    var locale = Localizations.localeOf(context).toString();
    initializeDateFormatting(locale);

    var formatter = new DateFormat(
        'dd.MM.yyyy (EEEEE)', Localizations.localeOf(context).toString());
    return formatter.format(d);
  }

  static String formatApiDate(DateTime d) {
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(d);
  }

  static DateTime getDateWithoutTime(DateTime d) {
    return DateTime.parse(formatApiDate(d));
  }

  static String formatApiDate2(DateTime d) {
    var formatter = new DateFormat('dd-MM-yyy');
    return formatter.format(d);
  }

  static String formatHour(DateTime d) {
    if (d == null) return "";
    var formatter = new DateFormat('HH:mm');
    return formatter.format(d);
  }

  static String getShortMonthName(BuildContext context, int m) {
    var locale = Localizations.localeOf(context).toString();
    initializeDateFormatting(locale);
    var formatter = new DateFormat('M');
    var formatter2 = new DateFormat('MMM', locale);

    var dateTime = formatter.parse(m.toString());

    return formatter2.format(dateTime);
  }

  static String getFullMonthName(BuildContext context, int m) {
    var locale = Localizations.localeOf(context).toString();
    initializeDateFormatting(locale);
    var formatter = new DateFormat('M');
    var formatter2 = new DateFormat('MMMM', locale);

    var dateTime = formatter.parse(m.toString());

    return formatter2.format(dateTime);
  }

  static String getFullMonthNameFromDate(BuildContext context, DateTime date) {
    var locale = Localizations.localeOf(context).toString();
    initializeDateFormatting(locale);
    DateFormat monthFormat = new DateFormat("LLLL yyyy", locale);

    return monthFormat.format(date);
  }

  static DateTime getLastDayOfMonth(int selectedYear, int selectedMonth) {
    DateTime lastDayOfMonth = new DateTime(selectedYear, selectedMonth + 1, 0);
    return lastDayOfMonth;
  }

  static String formatDateTime(DateTime d) {
    if (d == null) return "";

    var formatter = new DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(d);
  }

  static String formatSeconds(int seconds) {
    if (seconds == null) return "";
    if (seconds >= 60) {
      return "${(seconds ~/ 60).toString().padLeft(2, "0")}:${(seconds % 60)
          .toString()
          .padLeft(2, "0")}";
    }
    return "00:${seconds.toString().padLeft(2, "0")}";
  }

  static String getMinutesPart(int seconds) {
    if (seconds == null) return "";
    if (seconds > 60) {
      return "${(seconds ~/ 60).toString().padLeft(2, "0")}";
    }
    return "00";
  }

  static String getSecondsPart(int seconds) {
    if (seconds == null) return "";
    if (seconds > 60) {
      return "${(seconds % 60).toString().padLeft(2, "0")}";
    }
    return "${seconds.toString().padLeft(2, "0")}";
  }

  static DateTime mergeDateAndHour(DateTime date, String hour) {
    if (hour != null) {
      var split = hour.split(":");
      int hours = int.parse(split[0]);
      int minutes = int.parse(split[1]);
      return date.add(new Duration(hours: hours, minutes: minutes));
    }

    return null;
  }

  static DateTime firstDayOfTheWeek() {
    var now = new DateTime.now();
    var weekday = now.weekday;
    if (weekday != 1) {
      now = now.subtract(new Duration(days: weekday - 1));
    }

    return now;
  }

  static DateTime lastDayOfTheWeek() {
    var now = new DateTime.now();
    var weekday = now.weekday;
    if (weekday != 7) {
      now = now.add(new Duration(days: weekday - 1));
    }

    return now;
  }

  static const _daysInMonth = const [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];

  static bool isLeapYear(int value) =>
      value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);

  static int daysInMonth(int year, int month) {
    var result = _daysInMonth[month];
    if (month == 2 && isLeapYear(year)) result++;
    return result;
  }

  static DateTime addMonths(DateTime dt, int value) {
    var r = value % 12;
    var q = (value - r) ~/ 12;
    var newYear = dt.year + q;
    var newMonth = dt.month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    var newDay = min(dt.day, daysInMonth(newYear, newMonth));
    if (dt.isUtc) {
      return new DateTime.utc(newYear, newMonth, newDay, dt.hour, dt.minute,
          dt.second, dt.millisecond, dt.microsecond);
    } else {
      return new DateTime(newYear, newMonth, newDay, dt.hour, dt.minute,
          dt.second, dt.millisecond, dt.microsecond);
    }
  }

  static DateTime removeDayAndTime(DateTime date) {
    return new DateTime(date.year, date.month, 1, 0, 0, 0, 0, 0);
  }

  static String getTranlatedTimeAgo(BuildContext context, DateTime dt) {
    if(dt!=null){
      timeago.setLocaleMessages('pl', timeago.PlMessages());
      timeago.setLocaleMessages('en', timeago.EnMessages());
      var difference = new DateTime.now().difference(dt);
      return timeago.format(new DateTime.now().subtract(difference), locale: Localizations.localeOf(context).languageCode);
    }
    else return "";
  }

  static bool is234(int v){
    var mod = v % 10;
    return (mod == 2 || mod == 3 || mod == 4) && (v / 10) != 1;
  }

}

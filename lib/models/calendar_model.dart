import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

class CalendarModel extends ChangeNotifier {
  DateTime now = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  Future<void> init() async {}

  DateTime get firstDayOfMonth =>
      DateTime(focusedDay.year - 1, focusedDay.month, 1);

  DateTime get lastDayOfMonth =>
      DateTime(focusedDay.year, focusedDay.month + 1, 0);
}

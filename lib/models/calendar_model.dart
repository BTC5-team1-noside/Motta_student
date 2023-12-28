import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarModel extends ChangeNotifier {
  DateTime now = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  Future<void> init() async {
    debugPrint("$focusedDay");
  }

  DateTime get firstDayOfMonth =>
      DateTime(focusedDay.year, focusedDay.month, 1);
  // DateTime get firstDayOfMonth => DateTime(now.year, now.month, 1);

  DateTime get lastDayOfMonth =>
      DateTime(focusedDay.year, focusedDay.month + 1, 0);
  // DateTime get lastDayOfMonth => DateTime(now.year, now.month + 1, 0);

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(this.selectedDay, selectedDay)) {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
      notifyListeners();
    }
  }

  void onMonthChanged(DateTime day) {
    // フォーカスされている日を更新
    // focusedDay = DateTime(focusedDay.year, focusedDay.month - 1, 1);
    // ここで新しい月のデータをフェッチするロジックを追加できます
    // 例: fetchScheduleForMonth(focusedDay.month);
    notifyListeners(); // UIを更新
  }

  List<dynamic> fetchScheduleForDay(DateTime dateTime) {
    final schedule = {
      '1': ['on', 'off'],
      '2': ['off', 'on'],
      '3': ['on', 'on'],
      '4': ['on', 'on'],
    };
    return schedule[dateTime.day.toString()] ?? [null, null];
  }
}

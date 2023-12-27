import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student/models/calendar_model.dart';
import 'package:student/widgets/custom_calendar_builders.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final List<dynamic> data;
  const CalendarPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarModel>(
      create: (_) => CalendarModel()..init(),
      child: Consumer<CalendarModel>(builder: (context, model, snapshot) {
        final CustomCalendarBuilders customCalendarBuilders =
            CustomCalendarBuilders();

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TableCalendar<dynamic>(
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                  weekendStyle: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                  dowTextFormatter: (date, locale) {
                    switch (date.weekday) {
                      case 1:
                        return "げつ";
                      case 2:
                        return "か";
                      case 3:
                        return "すい";
                      case 4:
                        return "もく";
                      case 5:
                        return "きん";
                      case 6:
                        return "ど";
                      case 7:
                        return "にち";
                      default:
                        return "";
                    }
                  },
                ),
                focusedDay: model.focusedDay,
                firstDay: model.firstDayOfMonth,
                lastDay: model.lastDayOfMonth,
                locale: Localizations.localeOf(context).languageCode,
                // markerBuilderの大きさに合わせて調整してください
                rowHeight: 100,
                // 曜日文字の大きさに合わせて調整してください
                // 日本語だとこのくらいで見切れなくなります
                daysOfWeekHeight: 100,
                // 見た目をスッキリさせるためなのでなくても大丈夫です
                headerStyle: HeaderStyle(
                  titleTextStyle: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w600,
                  ),
                  titleTextFormatter: (date, locale) {
                    return DateFormat("yyyyねん　Mがつ", locale).format(date);
                  },
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(fontSize: 21),
                  // true（デフォルト）の場合は
                  // todayBuilderが呼ばれるので設定しましょう
                  isTodayHighlighted: false,
                ),
                // カスタマイズ用の関数を渡してやりましょう
                calendarBuilders: CalendarBuilders(
                  // dowBuilder: customCalendarBuilders.daysOfWeekBuilder,
                  // defaultBuilder: customCalendarBuilders.defaultBuilder,
                  defaultBuilder: (context, date, events) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('${date.day}',
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w600)),
                    );
                  },
                  disabledBuilder: customCalendarBuilders.disabledBuilder,
                  // selectedBuilder: customCalendarBuilders.selectedBuilder,
                  markerBuilder: (context, date, events) {
                    String dateOnly = DateFormat("yyyy-MM-dd").format(date);
                    if (data.contains(dateOnly)) {
                      return const Positioned(
                        right: 1,
                        bottom: 1,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      );
                    }
                    return null;
                  },
                ),
                // eventLoader: model.fetchScheduleForDay,
                selectedDayPredicate: (day) {
                  return isSameDay(model.selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  model.selectDay(selectedDay, focusedDay);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

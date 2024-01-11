import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student/models/calendar_model.dart';
import 'package:student/screens/student_login.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/elevated_button_with_style.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  final List<dynamic> data;
  const CalendarPage({super.key, required this.data, required this.studentId});
  final int studentId;

  @override
  Widget build(BuildContext context) {
    final int id = studentId % 5 == 0 ? 5 : studentId % 5;
    return ChangeNotifierProvider<CalendarModel>(
      create: (_) => CalendarModel()..init(),
      child: Consumer<CalendarModel>(builder: (context, model, snapshot) {
        return Scaffold(
          appBar: AppBarMotta(studentId: studentId),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
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
                    rowHeight: 120,
                    daysOfWeekHeight: 60,
                    headerStyle: HeaderStyle(
                      titleTextStyle: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w600,
                      ),
                      titleTextFormatter: (date, locale) {
                        return DateFormat("yyyyねん Mがつ", locale).format(date);
                      },
                      titleCentered: true,
                      formatButtonVisible: false,
                      leftChevronVisible: true,
                      rightChevronVisible: true,
                    ),
                    calendarStyle: const CalendarStyle(
                      defaultTextStyle: TextStyle(fontSize: 21),
                      isTodayHighlighted: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, events) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          padding: const EdgeInsets.all(2),
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                      markerBuilder: (context, date, events) {
                        String dateOnly = DateFormat("yyyy-MM-dd").format(date);
                        if (data.contains(dateOnly)) {
                          return Positioned(
                            top: 1,
                            child:
                                Image.asset('assets/images/stamps/char$id.PNG'),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                SizedBox(
                  height: 100,
                  child: ElevatedButtonWithStyle(
                    "さいしょにもどる",
                    studentId: studentId,
                    () {
                      if (!context.mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class Date {
  Date({required this.dateTime});
  final DateTime dateTime;

  @override
  String toString() {
    return dateTime.toString();
  }
}

class Subject {
  Subject({
    required this.period,
    required this.subject,
    required this.belongings,
  });
  final String period;
  final String subject;
  final List<String> belongings;
}

class DayBelongings {
  DayBelongings(
      {required this.selectedDate,
      required this.subjects,
      required this.items});

  final Date selectedDate;
  final List<Subject> subjects;
  final List<String> items;
}

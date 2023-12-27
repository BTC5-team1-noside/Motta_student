import 'package:student/models/belongings.dart';

class ConfirmsHistory {
  ConfirmsHistory({
    required this.date,
  });
  final Date date;

  factory ConfirmsHistory.fromJson(Map<String, dynamic> json) {
    return ConfirmsHistory(date: json["date"] as Date);
  }
}

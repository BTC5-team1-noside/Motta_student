import 'package:flutter/material.dart';
import "package:flutter_tts/flutter_tts.dart";
import 'package:student/screens/calendar_page.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:intl/intl.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({super.key, required this.tts});
  final FlutterTts tts;
  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  // late FlutterTts tts = FlutterTts();
  late FlutterTts tts;
  final String text = "ぜんぶかくにんできたね\nすごいぞ!\nキャッホー";
  @override
  void initState() {
    super.initState();
    tts = widget.tts;
    _speak();
  }

  Future<List<dynamic>> getCalendarData(BuildContext context,
      {String date = "2023-12-01", String studentId = "1"}) async {
    final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
        "/api/v1/student/confirms-history", {
      "student_id": studentId,
      "date": date,
    });
    try {
      // data fetching
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final data = json.decode(response.body);
      final addData1 = DateFormat("yyyy-MM-dd").format(DateTime(2023, 11, 30));
      final addData2 = DateFormat("yyyy-MM-dd").format(DateTime(2023, 11, 28));
      final addData3 = DateFormat("yyyy-MM-dd").format(DateTime(2023, 11, 26));
      final addData4 = DateFormat("yyyy-MM-dd").format(DateTime(2023, 11, 20));
      data.add(addData1);
      data.add(addData2);
      data.add(addData3);
      data.add(addData4);
      debugPrint("$data");
      // data.push(DateTime(2023, 11, 30));
      return data;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  void postConfirmDate(BuildContext context,
      {String date = "2023-12-01", String studentId = "1"}) async {
    final url = Uri.https(
        "motta-9dbb2df4f6d7.herokuapp.com", "/api/v1/student/confirms-history");
    final reqBodyDate = {
      "date": date,
      "student_id": studentId,
    };
    final reqBodyDateJson = json.encode(reqBodyDate);
    try {
      // data fetching
      await http.post(url,
          headers: {"Content-Type": "application/json"}, body: reqBodyDateJson);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _speak() async {
    await tts.setLanguage("ja-JP");
    // await tts.setPitch(1.3);
    // await tts.setSpeechRate(1.1);
    await tts.setVoice({
      // "name": "Yuna",
      // "locale": "ko-KR",
      "name": "O-Ren",
      "locale": "ja-JP",
    });
    await tts.speak(text);

    // ignore: use_build_context_synchronously
    postConfirmDate(context, date: "2023-12-22", studentId: "1");

    final data = await getCalendarData(
      context,
      date: "2023-12-01",
      studentId: "1",
    );

    tts.setCompletionHandler(() {
      // const String date = "2023-12-01";
      // const String studentId = "1";
      // // getCalendarData(
      // //   context,
      // //   date: date,
      // //   studentId: studentId,
      // // );
      Future.delayed(
        const Duration(seconds: 1),
        () {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CalendarPage(data: data),
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarMotta(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/end_background.PNG'), // 배경으로 사용할 이미지 경로
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/penguin/penguin_end.jpg"),
              BodyText(text: text),
            ],
          ),
        ),
      ),
    );
  }
}

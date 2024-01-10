import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import "package:flutter_tts/flutter_tts.dart";
import 'package:student/screens/calendar_page.dart';
import 'package:student/widgets/apis.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import "package:http/http.dart" as http;
import "dart:convert";
// import 'package:intl/intl.dart';

class EndScreen extends StatelessWidget {
  EndScreen({
    super.key,
    required this.studentId,
    required this.date,
  });

  final int studentId;
  final String date;
  final String text = "ぜんぶかくにんできたね\nすごいぞ!\nキャッホー";
  final AudioPlayer characterVoice = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final int id = studentId % 5 == 0 ? 5 : studentId % 5;

    Future<void> speak() async {
      postConfirmDate(date: date, studentId: studentId);

      await characterVoice.play(AssetSource('sounds/complete_char$id.wav'),
          volume: 0.3);

      final data = await getCalendarData(
        date: date,
        studentId: studentId,
      );

      characterVoice.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.completed) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CalendarPage(
                  data: data,
                  studentId: studentId,
                ),
              ),
            );
          });
        }
      });
    }

    speak();

    return Scaffold(
      appBar: const AppBarMotta(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/char$id/end_background.PNG'), // 배경으로 사용할 이미지 경로
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/char$id/character_end.jpg"),
              BodyText(text: text),
            ],
          ),
        ),
      ),
    );
  }
}






// class EndScreen extends StatefulWidget {
//   const EndScreen({
//     super.key,
//     required this.studentId,
//     required this.date,
//   });

//   final int studentId;
//   final String date;

//   @override
//   State<EndScreen> createState() => _EndScreenState();
// }

// class _EndScreenState extends State<EndScreen> {
//   final String text = "ぜんぶかくにんできたね\nすごいぞ!\nキャッホー";
//   final int _id = 1;
//   late int _studentId;

//   @override
//   void initState() {
//     super.initState();
//     _studentId = widget.studentId;
//     _speak();
//   }

//   Future<List<dynamic>> getCalendarData(BuildContext context,
//       {String date = "2023-01-01", int studentId = 1}) async {
//     final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
//         "/api/v1/student/confirms-history", {
//       "student_id": "$studentId",
//       "date": date,
//     });
//     try {
//       final response =
//           await http.get(url, headers: {"Content-Type": "application/json"});
//       final data = json.decode(response.body);

//       return data;
//     } catch (error) {
//       debugPrint(error.toString());
//       return [];
//     }
//   }

//   void postConfirmDate(BuildContext context,
//       {String date = "2023-12-01", int studentId = 1}) async {
//     final url = Uri.https(
//         "motta-9dbb2df4f6d7.herokuapp.com", "/api/v1/student/confirms-history");
//     final reqBodyDate = {
//       "date": date,
//       "student_id": "$studentId",
//     };
//     final reqBodyDateJson = json.encode(reqBodyDate);
//     try {
//       // data fetching
//       await http.post(url,
//           headers: {"Content-Type": "application/json"}, body: reqBodyDateJson);
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }

//   Future<void> _speak() async {
//     await tts.setLanguage("ja-JP");
//     // await tts.setPitch(1.3);
//     // await tts.setSpeechRate(1.1);
//     await tts.setVoice({
//       // "name": "Yuna",
//       // "locale": "ko-KR",
//       "name": "O-Ren",
//       "locale": "ja-JP",
//     });
//     await tts.speak(text);

//     // ignore: use_build_context_synchronously
//     postConfirmDate(context, date: "2024-01-01", studentId: _studentId);

//     final data = await getCalendarData(
//       context,
//       date: "2024-01-01",
//       studentId: _studentId,
//     );

//     tts.setCompletionHandler(() {
//       // const String date = "2023-12-01";
//       // const String studentId = "1";
//       // // getCalendarData(
//       // //   context,
//       // //   date: date,
//       // //   studentId: studentId,
//       // // );
//       Future.delayed(
//         const Duration(seconds: 1),
//         () {
//           if (!context.mounted) return;
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (ctx) => CalendarPage(
//                 data: data,
//                 studentId: _studentId,
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   @override
//   void dispose() {
//     tts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppBarMotta(),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//                 'assets/images/char$_id/end_background.PNG'), // 배경으로 사용할 이미지 경로
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Image.asset("assets/images/char$_id/character_end.jpg"),
//               BodyText(text: text),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

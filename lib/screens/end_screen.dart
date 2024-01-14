import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:student/screens/calendar_page.dart';
import 'package:student/widgets/apis.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';

class EndScreen extends StatelessWidget {
  EndScreen({
    super.key,
    required this.studentId,
    required this.date,
    required this.bgmController,
  });

  final int studentId;
  final String date;
  final String text = "ぜんぶかくにんできたね\nすごいぞ!\nキャッホー";
  AudioPlayer? characterVoice = AudioPlayer();
  AudioPlayer? bgmController;

  @override
  Widget build(BuildContext context) {
    final int id = studentId % 5 == 0 ? 5 : studentId % 5;

    Future<void> speak() async {
      postConfirmDate(date: date, studentId: studentId);

      Future.delayed(const Duration(seconds: 1), () async {
        await characterVoice!
            .play(AssetSource('sounds/complete_char$id.wav'), volume: 1.0);
      });

      final data = await getCalendarData(
        date: date,
        studentId: studentId,
      );

      characterVoice!.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.completed) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CalendarPage(
                  data: data,
                  studentId: studentId,
                  bgmController: bgmController!,
                  isFromEndScreen: true,
                ),
              ),
            );
          });
        }
      });
    }

    speak();

    return Scaffold(
      appBar: AppBarMotta(studentId: studentId),
      body: PopScope(
        onPopInvoked: (didPop) {
          bgmController = null;
          characterVoice = null;
        },
        child: Container(
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
                const SizedBox(
                  height: 150,
                ),
                Image.asset("assets/images/char$id/character_end.jpg"),
                BodyText(text: text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

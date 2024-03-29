import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:student/models/belongings.dart';
import "package:http/http.dart" as http;
import 'package:student/screens/calendar_page.dart';
import 'package:student/screens/end_screen.dart';
import "dart:convert";
import 'package:student/screens/ready_screen.dart';
import 'package:student/widgets/apis.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/elevated_button_with_style.dart';

class GameScreen extends StatelessWidget {
  GameScreen({super.key, required this.studentId});

  final int studentId;
  AudioPlayer? characterVoice = AudioPlayer();
  AudioPlayer? bgm = AudioPlayer();

  void _startButton(BuildContext context, {String date = "2024-01-09"}) async {
    await bgm!.setVolume(0.1);
    await characterVoice!.setReleaseMode(ReleaseMode.stop);
    await characterVoice!.play(AssetSource('sounds/start.mp3'), volume: 1.0);

    final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
        "/api/v1/student/timetables-history/$date");
    try {
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final data = json.decode(response.body);
      // debugPrint("${data["selectedDate"]}");
      DayBelongings dataFromJson = DayBelongings.fromJson(data);

      characterVoice!.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.completed) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ReadyScreen(
                  belongings: dataFromJson,
                  studentId: studentId,
                  date: date,
                  bgmController: bgm!,
                ),
              ),
            );
          });
        }
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // bgm.stop();
    // bgm.play(AssetSource('sounds/enchanted-chimes.mp3'), volume: 0.1);
    bgm!.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        bgm!.play(AssetSource('sounds/enchanted-chimes.mp3'), volume: 0.1);
      }
    });

    return Scaffold(
      appBar: AppBarMotta(studentId: studentId),
      body: PopScope(
        onPopInvoked: (didPop) {
          bgm = null;
          characterVoice = null;
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/start_page.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 900,
                ),
                SizedBox(
                  height: 100,
                  child: ElevatedButtonWithStyle("もちものかくにん　はじめ",
                      icon: Icons.play_circle_fill_rounded,
                      studentId: studentId, () {
                    final formatDate = DateFormat("yyyy-MM-dd");
                    DateTime currentDate = DateTime.now();
                    final formattedDate = formatDate.format(currentDate);
                    // _startButton(context, date: formattedDate);
                    _startButton(context, date: "2024-01-24");
                  }),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButtonWithStyle("かれんだーかくにん",
                      icon: Icons.event_rounded,
                      studentId: studentId, () async {
                    final formatDate = DateFormat("yyyy-MM-dd");
                    DateTime currentDate = DateTime.now();
                    final formattedDate = formatDate.format(currentDate);

                    final data = await getCalendarData(
                      date: formattedDate,
                      studentId: studentId,
                    );
                    if (!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => CalendarPage(
                          data: data,
                          studentId: studentId,
                          bgmController: bgm!,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

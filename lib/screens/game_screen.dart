import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:student/models/belongings.dart';
// import 'package:student/screens/play_screen.dart';
import "package:http/http.dart" as http;
import "dart:convert";

import 'package:student/screens/ready_screen.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/elevated_button_with_style.dart';

class GameScreen extends StatelessWidget {
  GameScreen({super.key});
  AudioPlayer penguinVoice = AudioPlayer();
  AudioPlayer bgm = AudioPlayer();

  //////////////////////////////////////////

  DayBelongings belongings = DayBelongings(
    selectedDate: "2023-12-20",
    subjects: [
      Subject(
        period: 1,
        subject: "国語",
        belongings: ["国語教科書", "国語のノート", "漢字ドリル"],
      ),
      Subject(
        period: 2,
        subject: "数学",
        belongings: ["数学教科書", "数学のノート", "三角定規"],
      ),
      Subject(
        period: 3,
        subject: "音楽",
        belongings: ["音楽教科書", "音楽のノート", "リコーダー"],
      )
    ],
    items: ["体操着", "エプロン", "箸いれ"],
    additionalItems: [],
  );

  //////////////////////////////////////////

  void _startButton(BuildContext context) async {
    await bgm.setVolume(0.1);
    await penguinVoice.play(AssetSource('sounds/start.mp3'), volume: 0.3);
    const date = "2023-12-20";

    final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
        "/api/v1/student/timetables-history/$date");
    debugPrint("$url");
    try {
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final data = json.decode(response.body);
      debugPrint("$data");
      DayBelongings dataFromJson = DayBelongings.fromJson(data);
      debugPrint("$dataFromJson");
      penguinVoice.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.completed) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (ctx) => ReadyScreen(belongings: dataFromJson)),
            );
          });
        }
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // late VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    bgm.stop();
    // bgm.play(AssetSource('sounds/enchanted-chimes.mp3'), volume: 0.2);
    bgm.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        bgm.play(AssetSource('sounds/enchanted-chimes.mp3'), volume: 0.1);
      }
    });

    return Scaffold(
      appBar: const AppBarMotta(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image.asset("images/start_page.png"), Chrome version
            Image.asset("assets/images/start_page.png"), // simulator version
            // Image.asset("assets/images/chick/chick.gif"),
            // Image.asset("assets/images/hamster/hamster.gif"),
            SizedBox(
              height: 100,
              child: ElevatedButtonWithStyle("もちものかくにん　はじめ", () {
                _startButton(context);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

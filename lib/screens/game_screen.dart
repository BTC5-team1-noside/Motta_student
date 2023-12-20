import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:student/models/belongings.dart';
// import 'package:student/screens/play_screen.dart';
// import "package:http/http.dart" as http;
// import "dart:convert";

import 'package:student/screens/ready_screen.dart';

class GameScreen extends StatelessWidget {
  GameScreen({super.key});
  AudioPlayer penguinVoice = AudioPlayer();
  AudioPlayer bgm = AudioPlayer();

  //////////////////////////////////////////

  DayBelongings belongings = DayBelongings(
    selectedDate: Date(
      dateTime: DateTime(2023, 12, 20),
    ),
    subjects: [
      Subject(
        period: "1限",
        subject: "国語",
        belongings: ["国語教科書", "国語のノート", "漢字ドリル"],
      ),
      Subject(
        period: "2限",
        subject: "数学",
        belongings: ["数学教科書", "数学のノート", "三角定規"],
      ),
      Subject(
        period: "3限",
        subject: "音楽",
        belongings: ["音楽教科書", "音楽のノート", "リコーダー"],
      )
    ],
    items: ["体操着", "エプロン", "箸いれ"],
  );

  //////////////////////////////////////////

  void _startButton(BuildContext context) async {
    await bgm.setVolume(0.05);
    await penguinVoice.play(AssetSource('sounds/start.mp3'), volume: 0.0);
    const date = "2023-12-17";

    ///
    ///ここにサーバーからデータもらうコードを書き、belongingへ入れる
    ///https://motta-9dbb2df4f6d7.herokuapp.com/api/v1/student/timetable-history/2023-12-17
    // final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
    //     "api/v1/student/timetable-history/$date");
    // try {
    //   final response =
    //       await http.get(url, headers: {"Content-Type": "application/json"});
    //   final data = json.decode(response.body);
    //   debugPrint(data);
    // } catch (error) {
    //   debugPrint(error.toString());
    // }

    ///

    penguinVoice.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => ReadyScreen(belongings: belongings)),
        );
      }
    });
  }

  // late VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    // bgm.play(AssetSource('sounds/enchanted-chimes.mp3'), volume: 0.5);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Motta",
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        )),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("images/start_page.png"),
            // Image.asset("assets/images/chick/chick.gif"),
            // Image.asset("assets/images/hamster/hamster.gif"),
            SizedBox(
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 217, 66),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onPressed: () {
                  _startButton(context);
                },
                child: const Text(
                  "もちものかくにん　はじめ",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

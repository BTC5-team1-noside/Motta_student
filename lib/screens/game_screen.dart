import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:student/models/belongings.dart';
import "package:http/http.dart" as http;
import "dart:convert";

import 'package:student/screens/ready_screen.dart';
import 'package:student/widgets/elevated_button_with_style.dart';
import "package:student/widgets/voiceBoxApi.dart";

class GameScreen extends StatelessWidget {
  GameScreen({super.key});

  final AudioPlayer penguinVoice = AudioPlayer();
  final AudioPlayer bgm = AudioPlayer();

  final String text = "もちものかくにん はじめるよ!\nもってたら、「もった!」って、\nへんじしてね!";
  var readyVoice;

  void _startButton(BuildContext context, {String date = "2024-01-09"}) async {
    await bgm.setVolume(0.1);
    await penguinVoice.play(AssetSource('sounds/start.mp3'), volume: 0.3);

    final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
        "/api/v1/student/timetables-history/$date");
    try {
      // data fetching
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final data = json.decode(response.body);
      debugPrint("${data["selectedDate"]}");
      DayBelongings dataFromJson = DayBelongings.fromJson(data);

      ///
      penguinVoice.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.completed) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (ctx) => ReadyScreen(
                      belongings: dataFromJson, readyVoice: readyVoice)),
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
    // bgm.play(AssetSource('sounds/enchanted-chimes.mp3'), volume: 0.2);
    bgm.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        bgm.play(AssetSource('sounds/enchanted-chimes.mp3'), volume: 0.1);
      }
    });

    return Scaffold(
      // appBar: const AppBarMotta(),
      body: Container(
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
                height: 700,
              ),
              SizedBox(
                height: 100,
                child: ElevatedButtonWithStyle("もちものかくにん　はじめ", () {
                  const String date = "2024-01-12";
                  _startButton(context, date: date);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/play_screen.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import 'package:student/widgets/apis.dart';

class ReadyScreen extends StatelessWidget {
  ReadyScreen({
    super.key,
    required this.belongings,
    required this.studentId,
    required this.date,
    required this.bgmController,
  });

  final DayBelongings belongings;
  final int studentId;
  late dynamic voiceData;
  final String date;
  AudioPlayer? bgmController;
  late List voiceUrl;
  @override
  Widget build(BuildContext context) {
    AudioPlayer? characterVoice = AudioPlayer();
    final int id = studentId % 5 == 0 ? 5 : (studentId + 5) % 5;
    late List textList;
    // late List voiceData;
    const String text = "もちものかくにん はじめるよ!\nもってたら、「もった!」って、\nへんじしてね!";

    final List subjects = belongings.subjects;
    final List items = belongings.items;
    final List additionalItems = belongings.additionalItems;

    // void splitVoiceData() async {
    //   voiceData =
    //       await synthesizeVoice(text: textList[0], studentId: studentId);
    // }

    Future<void> speak() async {
      voiceUrl =
          await synthesizeVoiceUrl(text: textList[0], studentId: studentId);
      await characterVoice!
          .play(AssetSource('sounds/ready_char$id.wav'), volume: 1.0);

      characterVoice!.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.completed) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlayScreen(
                  belongings: belongings,
                  studentId: studentId,
                  // voiceData: voiceData,
                  voiceText: textList,
                  date: date,
                  bgmController: bgmController!,
                  voiceUrl: voiceUrl,
                ),
              ),
            );
          });
        }
      });
    }

    textList = createVoiceDate(
        subjects: subjects, items: items, additionalItems: additionalItems);
    // splitVoiceData();
    // print(textList);
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
              image: AssetImage('assets/images/char$id/normal_background.PNG'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/char$id/character.jpg"),
                const SizedBox(
                  height: 100,
                ),
                Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(150, 244, 248, 250),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    height: 250,
                    child: const BodyText(text: text)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

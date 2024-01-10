import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/play_screen.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import 'package:student/widgets/elevated_button_with_style.dart';
import 'package:student/widgets/apis.dart';

class ReadyScreen extends StatelessWidget {
  ReadyScreen({
    super.key,
    required this.belongings,
    required this.studentId,
    required this.date,
  });

  final DayBelongings belongings;
  final int studentId;
  late dynamic voiceData;
  final String date;

  @override
  Widget build(BuildContext context) {
    final AudioPlayer characterVoice = AudioPlayer();
    final int id = studentId % 5 == 0 ? 5 : studentId % 5;
    late List textList;
    late List voiceData;
    const String text = "もちものかくにん はじめるよ!\nもってたら、「もった!」って、\nへんじしてね!";

    final List subjects = belongings.subjects;
    final List items = belongings.items;
    final List additionalItems = belongings.additionalItems;

    List<String> createVoiceDate() {
      List<String> arrText = [];
      for (int index = 0; index < subjects.length + 1; index++) {
        String txt = "";
        if (index < subjects.length) {
          txt +=
              "${subjects[index].period} じかんめ、 ${subjects[index].subject}だよ！,\n";
          for (int i = 0; i < subjects[index].belongings.length; i++) {
            txt += "${subjects[index].belongings[i]}。、。";
          }
          txt += "もった？";
          arrText.add(txt);
        } else {
          txt += "いつもの。";
          for (int j = 0; j < items.length; j++) {
            txt += "${items[j]}。、。";
          }
          if (additionalItems.isNotEmpty) {
            txt += "あと。";
            for (int k = 0; k < additionalItems.length; k++) {
              txt += "${additionalItems[k]}も。、。";
            }
          }
          txt += "もった？";
          arrText.add(txt);
        }
      }
      debugPrint("ready_screen line 68:$arrText");
      return arrText;
    }

    void splitVoiceData() async {
      voiceData = await synthesizeVoice(textList[0]);
      print(voiceData);
    }

    Future<void> speak() async {
      await characterVoice.play(AssetSource('sounds/ready_char$id.wav'),
          volume: 0.3);

      characterVoice.onPlayerStateChanged.listen((event) {
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
                  voiceData: voiceData,
                  voiceText: textList,
                  date: date,
                ),
              ),
            );
          });
        }
      });
    }

    textList = createVoiceDate();
    splitVoiceData();
    speak();

    return Scaffold(
      appBar: const AppBarMotta(),
      body: Container(
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
              const BodyText(text: text),
            ],
          ),
        ),
      ),
    );
  }
}

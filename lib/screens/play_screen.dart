import 'dart:js_util';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/end_screen.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import 'package:student/widgets/elevated_button_with_style.dart';
import "package:flutter_tts/flutter_tts.dart";

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key, required this.belongings});

  final DayBelongings belongings;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late DayBelongings _belongings;
  late FlutterTts tts = FlutterTts();
  late List _subjects;
  late List _items;
  late List _additionalItems;
  int index = 0;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    _belongings = widget.belongings;
    _subjects = _belongings.subjects;
    _items = _belongings.items;
    _additionalItems = _belongings.additionalItems;
  }

  Future<void> speak(String text) async {
    await tts.setLanguage("ja-JP");
    await tts.setPitch(1.3);
    await tts.setVoice({
      // "name": "Yuna",
      // "locale": "ko-KR",
      "name": "O-Ren",
      "locale": "ja-JP",
    });
    await tts.setSpeechRate(0.8);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    String text = "";
    AssetImage backgroundPicture;
    List<Widget> main;

    if (index < _subjects.length) {
      text +=
          "${_subjects[index].period} じかんめ、 ${_subjects[index].subject}だよ！,\n";
      for (int i = 0; i < _subjects[index].belongings.length; i++) {
        text += "${_subjects[index].belongings[i]}。、。";
      }
      text += "もった？";
    } else {
      text += "日常品の。";
      for (int j = 0; j < _items.length; j++) {
        text += "${_items[j]}。、。";
      }
      if (_additionalItems.isNotEmpty) {
        text += "あと。";
        for (int k = 0; k < _additionalItems.length; k++) {
          text += "${_additionalItems[k]}も。、。";
        }
      }
      text += "もった？";
    }

    if (!answered) {
      speak(text);
    }
    // debugPrint(text);

    Widget mainContent;
    if (index < _subjects.length) {
      mainContent = Container(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: SizedBox(
          height: 250,
          child: ListView(
            children: [
              Text(
                "${_subjects[index].period} じかんめ ${_subjects[index].subject}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ..._subjects[index].belongings.map(
                    (e) => ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        title: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () async {
                          await tts.speak(e);
                        }),
                  ),
            ],
          ),
        ),
      );
    } else {
      mainContent = Container(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: SizedBox(
          height: 250,
          child: ListView(
            children: [
              const Text(
                "日常品の",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ..._items.map(
                (e) => ListTile(
                    title: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      await tts.speak(e);
                      // tts.setCompletionHandler(() {
                      //   Future.delayed(const Duration(milliseconds: 250), () {
                      //     if (!context.mounted) return;
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //           builder: (ctx) => const EndScreen()),
                      //     );
                      //   });
                      // });
                    }),
              ),
              if (_additionalItems.isNotEmpty)
                ..._additionalItems.map(
                  (e) => ListTile(
                      title: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () async {
                        await tts.speak(e);
                      }),
                ),
            ],
          ),
        ),
      );
    }

    if (!answered) {
      backgroundPicture = const AssetImage('assets/images/background.png');
      main = [
        mainContent,
        const BodyText(text: "もった？"),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButtonWithStyle("もった", () {
              setState(() {
                // index++;
                answered = true;
              });
            }),
            ElevatedButtonWithStyle("もういちど", () {
              setState(() {});
            }),
            ElevatedButtonWithStyle("やめる", () {}),
          ],
        )
      ];
      // 배경으로 사용할 이미지 경로
    } else {
      backgroundPicture = const AssetImage('assets/images/good_background.png');
      main = [const BodyText(text: "グッド！")];
      Future.delayed(const Duration(seconds: 1), () {
        if (index == _subjects.length) {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const EndScreen()),
          );
        }
        setState(() {
          index++;
          answered = false;
        });
      });
    }

    return Scaffold(
      appBar: const AppBarMotta(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundPicture, // 배경으로 사용할 이미지 경로
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/penguin/penguin10f.gif"),
              ...main,
            ],
          ),
        ),
      ),
    );
  }
}

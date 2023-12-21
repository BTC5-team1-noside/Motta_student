import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/end_screen.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import 'package:student/widgets/elevated_button_with_style.dart';
import 'package:student/widgets/subject_speak.dart';
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
  int index = 0;

  @override
  void initState() {
    super.initState();
    _belongings = widget.belongings;
    _subjects = _belongings.subjects;
    _items = _belongings.items;
  }

  Future<void> speak(String text) async {
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainComment;
    if (index < _subjects.length) {
      mainComment = Container(
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
                          setState(() {
                            index++;
                          });
                        }),
                  ),
            ],
          ),
        ),
      );
    } else {
      mainComment = Container(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: SizedBox(
          height: 250,
          child: ListView(
            children: [
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
                      tts.setCompletionHandler(() {
                        Future.delayed(const Duration(milliseconds: 250), () {
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => const EndScreen()),
                          );
                        });
                      });
                    }),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const AppBarMotta(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/background.png'), // 배경으로 사용할 이미지 경로
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/penguin/penguin10f.gif"),
              // Image.asset("assets/images/chick/chick.gif"),
              // Image.asset("assets/images/hamster/hamster.gif"),
              mainComment,
              const BodyText(text: "もった？"),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButtonWithStyle("もった", () {}),
                  ElevatedButtonWithStyle("もういちど", () {}),
                  ElevatedButtonWithStyle("やめる", () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

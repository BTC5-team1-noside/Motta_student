import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:student/models/belongings.dart';
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
  late List<Subject> _subjects;
  late List<String> _items;
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
        child: Column(
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
            const Text(
              "もった？",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      mainComment = Container(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Column(
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
                  }),
            ),
            const Text(
              "もった？",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

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
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/penguin/penguin10f.gif"),
              // Image.asset("assets/images/chick/chick.gif"),
              // Image.asset("assets/images/hamster/hamster.gif"),
              mainComment,
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 217, 66),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {},
                    child: const Text(
                      "もった",
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 217, 66),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {},
                    child: const Text(
                      "もういちど",
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 217, 66),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {},
                    child: const Text(
                      "やめる",
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

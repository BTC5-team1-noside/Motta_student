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

  @override
  void initState() {
    super.initState();
    _belongings = widget.belongings;
  }

  Future<void> speak(String text) async {
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Motta",
          style: TextStyle(
            fontSize: 35,
          ),
        )),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/images/penguin/penguin10f.gif"),
            // Image.asset("assets/images/chick/chick.gif"),
            // Image.asset("assets/images/hamster/hamster.gif"),
            SubjectSpeak(subject: _belongings.subjects[0]),
            // FruitListScreen(),
            ..._belongings.items.map((item) => Text(item)),
          ],
        ),
      ),
    );
  }
}

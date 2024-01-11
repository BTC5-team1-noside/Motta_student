import 'package:flutter/material.dart';
import "package:flutter_tts/flutter_tts.dart";
import 'package:student/models/belongings.dart';

class SubjectSpeak extends StatefulWidget {
  const SubjectSpeak({super.key, required this.subject});
  final Subject subject;

  @override
  State<SubjectSpeak> createState() => _SubjectSpeakState();
}

class _SubjectSpeakState extends State<SubjectSpeak> {
  late FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    tts.setLanguage("ja-JP");
    tts.setPitch(4.2);
  }

  @override
  void dispose() {
    super.dispose();
    tts.stop();
  }

  @override
  Widget build(BuildContext context) {
    // tts.speak(widget.subject.belongings[0]);
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await tts.speak(widget.subject.belongings[0]);
          },
          child: Text(widget.subject.belongings[0]),
        ),
      ],
    );
  }
}

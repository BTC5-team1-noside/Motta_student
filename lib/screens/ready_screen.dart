import 'package:flutter/material.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/play_screen.dart';
// import 'package:student/widgets/subject_speak.dart';
import "package:flutter_tts/flutter_tts.dart";
import 'package:student/widgets/appbar_motta.dart';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key, required this.belongings});

  final DayBelongings belongings;

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  late DayBelongings _belongings;
  late FlutterTts tts = FlutterTts();
  final String text = "もちものかくにん はじめるよ!\nもってたら、「もった!」って、\nへんじしてね!";
  @override
  void initState() {
    super.initState();
    _belongings = widget.belongings;
    _speak();
  }

  Future<void> _speak() async {
    await tts.setLanguage("ja-JP");
    await tts.setPitch(1.3);
    await tts.setVoice({
      // "name": "Yuna",
      // "locale": "ko-KR",
      "name": "O-Ren",
      "locale": "ja-JP",
    });
    await tts.setSpeechRate(1.1);
    // final voices = await tts.getVoices;
    // debugPrint(voices.toString());
    await tts.speak(text);

    tts.setCompletionHandler(() {
      Future.delayed(const Duration(seconds: 1), () {
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => PlayScreen(belongings: _belongings)),
        );
      });
    });
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarMotta(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("images/penguin/penguin.jpg"),
            // Image.asset("assets/images/chick/chick.gif"),
            // Image.asset("assets/images/hamster/hamster.gif"),
            const SizedBox(
              height: 100,
            ),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

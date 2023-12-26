import 'package:flutter/material.dart';
import "package:flutter_tts/flutter_tts.dart";
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({super.key});

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  late FlutterTts tts = FlutterTts();
  final String text = "ぜんぶかくにんできたね\nすごいぞ〜〜〜〜";
  @override
  void initState() {
    super.initState();
    _speak();
  }

  Future<void> _speak() async {
    await tts.setLanguage("ja-JP");
    // await tts.setPitch(1.3);
    await tts.setVoice({
      // "name": "Yuna",
      // "locale": "ko-KR",
      "name": "O-Ren",
      "locale": "ja-JP",
    });
    // await tts.setSpeechRate(1.1);
    await tts.speak(text);

    tts.setCompletionHandler(() {
      Future.delayed(const Duration(seconds: 1), () {
        if (!context.mounted) return;
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (ctx) => PlayScreen(belongings: _belongings)),
        // );
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/end_background.PNG'), // 배경으로 사용할 이미지 경로
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/penguin/penguin_end.jpg"),
              BodyText(text: text),
            ],
          ),
        ),
      ),
    );
  }
}

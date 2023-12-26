import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/end_screen.dart';
import 'package:student/screens/game_screen.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import 'package:student/widgets/elevated_button_with_style.dart';
import "package:flutter_tts/flutter_tts.dart";
import "package:student/widgets/list_tile_with_speak.dart";

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key, required this.belongings, required this.tts});

  final DayBelongings belongings;
  final FlutterTts tts;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // Data
  late DayBelongings _belongings;
  late List _subjects;
  late List _items;
  late List _additionalItems;

  //control flag
  int index = 0;
  bool answered = false;
  bool isListening = false;
  bool isOnce = false;

  // instance
  late FlutterTts tts;
  SpeechToText speechToText = SpeechToText();
  Timer? _listeningTimer; //timerで一定時間過ぎて回答がないならもう一度読み上げるのを実装するかもしれないため、残しておく。

  @override
  void initState() {
    super.initState();
    tts = widget.tts;
    _belongings = widget.belongings;
    _subjects = _belongings.subjects;
    _items = _belongings.items;
    _additionalItems = _belongings.additionalItems;
  }

  @override
  void dispose() {
    tts.stop();
    _listeningTimer?.cancel();
    super.dispose();
  }

  //////////////////////////////////
  ////音声認識
  void _startListening() async {
    var available = await speechToText.initialize();
    if (available) {
      isListening = true;
      speechToText.listen(
        onResult: (result) {
          if (result.recognizedWords.contains("持った")) {
            debugPrint("$result");
            _stopListening();
            if (isOnce == true) {
              setState(() {
                answered = true;
              });
            }
          }
        },
        localeId: 'ja_JP', // 日本語の設定
      );

      // 4秒後にリスニングを停止
      // _listeningTimer = Timer(const Duration(seconds: 4), () {
      //   if (isListening) {
      //     speechToText.stop();
      //     // setState(() {
      //     isListening = false;
      //     // });
      //   }
      // });
    }
  }

  void _stopListening() {
    if (isListening) {
      speechToText.stop();
      isListening = false;
      // _listeningTimer?.cancel(); // タイマーが動いていたら停止
    }
  }

  ///////////////////////////////////

  ///////////////////////////////////
  /// TTS

  Future<void> speak(String text) async {
    await tts.setLanguage("ja-JP");
    // await tts.setPitch(1.3);
    // await tts.setSpeechRate(0.8);
    await tts.setVoice({
      "name": "O-Ren",
      "locale": "ja-JP",
    });
    await tts.speak(text);
    tts.setCompletionHandler(() {
      isOnce = true;
      _startListening();
    });
  }
  /////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    debugPrint("indexは、$index");
    String text = "";
    AssetImage backgroundPicture;
    Widget mainContent;
    List<Widget> bodyMain;

    // 読み上げtextと生成
    if (index < _subjects.length) {
      text +=
          "${_subjects[index].period} じかんめ、 ${_subjects[index].subject}だよ！,\n";
      for (int i = 0; i < _subjects[index].belongings.length; i++) {
        text += "${_subjects[index].belongings[i]}。、。";
      }
      text += "もった？";
    } else {
      text += "いつもの。";
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

    if (!isListening) {
      if (!answered) {
        speak(text);
      }
    }

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
                    (e) => ListTileWithSpeak(tts: tts, item: e),
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
                "いつもの、",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ..._items.map((e) => ListTileWithSpeak(tts: tts, item: e)),
              if (_additionalItems.isNotEmpty)
                ..._additionalItems
                    .map((e) => ListTileWithSpeak(tts: tts, item: e)),
            ],
          ),
        ),
      );
    }

    if (!answered) {
      backgroundPicture = const AssetImage('assets/images/background.PNG');
      bodyMain = [
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
                answered = true;
                isOnce = false;
                isListening = false;
              });
            }),
            ElevatedButtonWithStyle("もういちど", () {
              setState(() {});
            }),
            ElevatedButtonWithStyle("やめる", () {
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => GameScreen()));
            })
          ],
        )
      ];
    } else {
      backgroundPicture = const AssetImage('assets/images/good_background.PNG');
      bodyMain = [const BodyText(text: "グッド！")];
      isOnce = false;
      Future.delayed(const Duration(seconds: 1), () {
        if (index == _subjects.length) {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => EndScreen(tts: tts)),
          );
        } else {
          setState(() {
            index++;
            answered = false;
          });
        }
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
              ...bodyMain,
            ],
          ),
        ),
      ),
    );
  }
}

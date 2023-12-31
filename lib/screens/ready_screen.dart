import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/play_screen.dart';
import "package:flutter_tts/flutter_tts.dart";
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
// import "package:just_audio/just_audio.dart";
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({
    super.key,
    required this.belongings,
    required this.characterVoice,
  });

  final DayBelongings belongings;
  final AudioPlayer characterVoice;

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  late AudioPlayer characterVoice;

  final int _id = 1;
  late DayBelongings _belongings;
  late List _subjects;
  late List _items;
  late List _additionalItems;

  late FlutterTts tts = FlutterTts();
  final String text = "もちものかくにん はじめるよ!\nもってたら、「もった!」って、\nへんじしてね!";

  // void playVoiceFromData(data) async {
  //   final source = MyStreamAudioSource(data);
  //   await characterVoice.setAudioSource(source);
  //   characterVoice.play();
  // }

  @override
  void initState() {
    super.initState();
    _belongings = widget.belongings;
    _subjects = _belongings.subjects;
    _items = _belongings.items;
    _additionalItems = _belongings.additionalItems;
    createVoiceDate();
    characterVoice = widget.characterVoice;
    _speak();
  }

  List<String> createVoiceDate() {
    // 読み上げtextと生成
    List<String> arrText = [];
    for (int index = 0; index < _subjects.length + 1; index++) {
      String txt = "";
      if (index < _subjects.length) {
        txt +=
            "${_subjects[index].period} じかんめ、 ${_subjects[index].subject}だよ！,\n";
        for (int i = 0; i < _subjects[index].belongings.length; i++) {
          txt += "${_subjects[index].belongings[i]}。、。";
        }
        txt += "もった？";
        arrText.add(txt);
      } else {
        txt += "いつもの。";
        for (int j = 0; j < _items.length; j++) {
          txt += "${_items[j]}。、。";
        }
        if (_additionalItems.isNotEmpty) {
          txt += "あと。";
          for (int k = 0; k < _additionalItems.length; k++) {
            txt += "${_additionalItems[k]}も。、。";
          }
        }
        txt += "もった？";
        arrText.add(txt);
      }
    }
    print(arrText);
    return arrText;
  }

  Future<void> _speak() async {
    // playVoiceFromData(readyVoice);

    await characterVoice.play(AssetSource('sounds/ready_char1.wav'),
        volume: 0.3);

    characterVoice.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        characterVoice.stop();
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (!context.mounted) return;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => PlayScreen(belongings: _belongings, tts: tts)));
        });
      }
    });
  }

  // オーディオの終了を検知します。
  // characterVoice.playerStateStream.listen((state) {
  //   // playerStateStreamは複数の状態変更を送出する可能性があるため、
  //   // 完了したかどうかを確認する必要があります。
  //   if (state.processingState == ProcessingState.completed) {
  //     // コンテキストや他の必要なパラメータを適宜調整してください。
  //     if (!context.mounted) return;
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //           builder: (ctx) => PlayScreen(belongings: _belongings, tts: tts)),
  //     );
  //   }
  // }

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarMotta(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/char$_id/normal_background.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/char$_id/character.jpg"),
              // Image.asset("assets/images/chick/chick.gif"),
              // Image.asset("assets/images/hamster/hamster.gif"),
              const SizedBox(
                height: 100,
              ),
              BodyText(text: text),
            ],
          ),
        ),
      ),
    );
  }
}

// class MyStreamAudioSource extends StreamAudioSource {
//   final audioData;

//   MyStreamAudioSource(this.audioData);

//   @override
//   Future<StreamAudioResponse> request([int? start, int? end]) async {
//     start ??= 0;
//     end = end ?? audioData.length;

//     return StreamAudioResponse(
//       sourceLength: audioData.length,
//       contentLength: end! - start,
//       offset: start,
//       contentType: "audio/mpeg",
//       stream: Stream.value(audioData.sublist(start, end)),
//     );
//   }
// }

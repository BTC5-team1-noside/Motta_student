import 'package:flutter/material.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/play_screen.dart';
import "package:flutter_tts/flutter_tts.dart";
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import "package:just_audio/just_audio.dart";
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({
    super.key,
    required this.belongings,
  });

  final DayBelongings belongings;

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

  final int _id = 1;
  late DayBelongings _belongings;
  late FlutterTts tts = FlutterTts();
  final String text = "もちものかくにん はじめるよ!\nもってたら、「もった!」って、\nへんじしてね!";

  void playVoiceFromData(data) async {
    final source = MyStreamAudioSource(data);
    await audioPlayer.setAudioSource(source);
    audioPlayer.play();
  }

  @override
  void initState() {
    super.initState();
    _belongings = widget.belongings;
    _speak();
  }

  Future<void> _speak() async {
    await tts.setLanguage("ja-JP");
    await tts.setPitch(1.3);
    await tts.setSpeechRate(1.0);
    await tts.setVoice({
      "name": "O-Ren",
      "locale": "ja-JP",
    });

    // playVoiceFromData(readyVoice);

    // オーディオの終了を検知します。
    audioPlayer.playerStateStream.listen((state) {
      // playerStateStreamは複数の状態変更を送出する可能性があるため、
      // 完了したかどうかを確認する必要があります。
      if (state.processingState == ProcessingState.completed) {
        // コンテキストや他の必要なパラメータを適宜調整してください。
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => PlayScreen(belongings: _belongings, tts: tts)),
        );
      }
    });
    // await tts.speak(text);

    // tts.setCompletionHandler(() {
    //   Future.delayed(const Duration(seconds: 1), () {
    //     if (!context.mounted) return;
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //           builder: (ctx) => PlayScreen(belongings: _belongings, tts: tts)),
    //     );
    //   });
    // });
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tts.stop();
  }

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

class MyStreamAudioSource extends StreamAudioSource {
  final audioData;

  MyStreamAudioSource(this.audioData);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end = end ?? audioData.length;

    return StreamAudioResponse(
      sourceLength: audioData.length,
      contentLength: end! - start,
      offset: start,
      contentType: "audio/mpeg",
      stream: Stream.value(audioData.sublist(start, end)),
    );
  }
}

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
  const ReadyScreen({super.key, required this.belongings});

  final DayBelongings belongings;

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  void playVoiceFromData(Uint8List data) async {
    final source = MyStreamAudioSource(data);
    await audioPlayer.setAudioSource(source);
    audioPlayer.play();
  }

  late DayBelongings _belongings;
  late FlutterTts tts = FlutterTts();
  final String text = "もちものかくにん はじめるよ!\nもってたら、「もった!」って、\nへんじしてね!";

  Future<void> synthesizeVoice(text) async {
    var dynamicUrl =
        "https://fb73-133-106-63-3.ngrok-free.app"; //ここのアドレスがエンジンを立ち上げ直す毎に変わるよ！！
    var url = '$dynamicUrl/audio_query?text=$text&speaker=32';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        'text': text,
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var audioQuery = body;

      // 生成したクエリを使って実際に音声を生成する
      var synthesisHost = 'localhost:50021';
      var synthesisPath = '/synthesis';
      var synthesisResponse = await http.post(
        Uri.http(
          synthesisHost,
          synthesisPath,
          {
            "speaker": "32", //speakerのvalueを変更することで話者を変更
          },
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(audioQuery),
      );
      if (synthesisResponse.statusCode == 200) {
        final data = synthesisResponse.bodyBytes;
        // debugPrint("$data");

        playVoiceFromData(data);
        debugPrint('音声生成成功!');
      } else {
        debugPrint('音声生成失敗: ${synthesisResponse.reasonPhrase}');
      }
    } else {
      debugPrint('クエリ生成失敗: ${response.reasonPhrase}');
    }
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
    await synthesizeVoice(text);

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/penguin/penguin.jpg"),
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
  final Uint8List audioData;

  MyStreamAudioSource(this.audioData);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end = end ?? audioData.length;

    return StreamAudioResponse(
      sourceLength: audioData.length,
      contentLength: end - start,
      offset: start,
      contentType: "audio/mpeg",
      stream: Stream.value(audioData.sublist(start, end)),
    );
  }
}

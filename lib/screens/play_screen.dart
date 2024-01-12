import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:student/models/belongings.dart';
import 'package:student/screens/end_screen.dart';
import 'package:student/screens/student_login.dart';
import 'package:student/widgets/appbar_motta.dart';
import 'package:student/widgets/body_text.dart';
import 'package:student/widgets/elevated_button_with_style.dart';
import "package:student/widgets/list_tile_with_speak.dart";
import 'package:student/widgets/apis.dart';
import "package:audioplayers/audioplayers.dart" as audio_player;

class PlayScreen extends StatefulWidget {
  const PlayScreen({
    super.key,
    required this.belongings,
    required this.studentId,
    required this.voiceData,
    required this.voiceText,
    required this.date,
    required this.bgmController,
    required this.voiceUrl,
  });

  final DayBelongings belongings;
  final int studentId;
  final dynamic voiceData;
  final List voiceText;
  final String date;
  final audio_player.AudioPlayer bgmController;
  final String voiceUrl;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late DayBelongings _belongings;
  late List _subjects;
  late List _items;
  late List _additionalItems;
  late int _studentId;
  late dynamic _voiceData;
  late dynamic _downloadVoiceData;
  late List _voiceText;
  late String _date;
  late dynamic _bgmController;
  late String _voiceUrl;
  late String _nextVoiceUrl;

  int index = 0;
  bool answered = false;
  bool isListening = false;
  bool isOnce = false;
  late int _id;
  bool isVoiceFinished = false;
  bool isSttAvailable = false;

  SpeechToText speechToText = SpeechToText();
  Timer? _listeningTimer;
  final just_audio.AudioPlayer characterVoice = just_audio.AudioPlayer();
  final just_audio.AudioPlayer soundEffect = just_audio.AudioPlayer();

  @override
  void initState() {
    super.initState();
    _belongings = widget.belongings;
    _subjects = _belongings.subjects;
    _items = _belongings.items;
    _additionalItems = _belongings.additionalItems;
    _studentId = widget.studentId;
    _voiceData = widget.voiceData;
    _voiceText = widget.voiceText;
    _date = widget.date;
    _bgmController = widget.bgmController;
    _voiceUrl = widget.voiceUrl;
  }

  @override
  void dispose() {
    _listeningTimer?.cancel();
    super.dispose();
  }

  void _startListening() async {
    // var available = await speechToText.initialize();
    if (isSttAvailable) {
      isListening = true;
      speechToText.listen(
        onResult: (result) {
          if (result.recognizedWords.contains("持った")) {
            debugPrint("$result");
            _stopListening();
            if (isOnce == true) {
              soundEffect.setAsset("sounds/good.mp3");
              soundEffect.play();
              setState(() {
                answered = true;
              });
            }
          }
        },
        localeId: 'ja_JP',
      );
    }
  }

  void _stopListening() {
    if (isListening) {
      speechToText.stop();
      isListening = false;
    }
  }

  Future<void> speak() async {
    // playVoiceFromData(data: _voiceData, audioPlayer: characterVoice);
    // print(_voiceUrl);
    characterVoice.setUrl(_voiceUrl);
    while (true) {
      if (await isMp3Available(incomingUrl: _voiceUrl)) {
        Future.delayed(const Duration(milliseconds: 250));
      } else {
        break;
      }
    }
    characterVoice.play();
    if (index < _subjects.length) {
      // _downloadVoiceData = await synthesizeVoice(
      //   text: _voiceText[index + 1],
      //   studentId: _studentId,
      // );
      _nextVoiceUrl = await synthesizeVoiceUrl(
          text: _voiceText[index + 1], studentId: _studentId);
      print("nextUrl:$_nextVoiceUrl");
    }

    characterVoice.playerStateStream.listen((state) {
      if (state.processingState == just_audio.ProcessingState.completed) {
        isOnce = true;
        isVoiceFinished = true;
        setState(() {});
        // _voiceData = _downloadVoiceData;
        _voiceUrl = _nextVoiceUrl;
        _startListening();
      }
    });
  }

  void initStt() async {
    isSttAvailable = await speechToText.initialize();
  }

  @override
  Widget build(BuildContext context) {
    _id = _studentId % 5 == 0 ? 5 : _studentId % 5;
    debugPrint("play_screen line:126: $_id");
    AssetImage backgroundPicture;
    Widget mainContent;
    List<Widget> bodyMain;

    if (!isSttAvailable) {
      initStt();
    }

    if (!isVoiceFinished) {
      if (!isListening) {
        if (!answered) {
          speak();
        }
      }
    }

    if (index < _subjects.length) {
      mainContent = Container(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Color.fromARGB(150, 244, 248, 250),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
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
                    // (e) => ListTileWithSpeak(tts: tts, item: e),
                    (e) => ListTileWithSpeak(item: e),
                  ),
            ],
          ),
        ),
      );
    } else {
      mainContent = Container(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Color.fromARGB(150, 244, 248, 250),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
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
              // ..._items.map((e) => ListTileWithSpeak(tts: tts, item: e)),
              ..._items.map((e) => ListTileWithSpeak(item: e)),
              if (_additionalItems.isNotEmpty)
                ..._additionalItems
                    // .map((e) => ListTileWithSpeak(tts: tts, item: e)),
                    .map((e) => ListTileWithSpeak(item: e)),
            ],
          ),
        ),
      );
    }

    if (!answered) {
      backgroundPicture =
          AssetImage('assets/images/char$_id/normal_background.PNG');
      if (isVoiceFinished) {
        bodyMain = [
          mainContent,
          const BodyText(text: "もった？"),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButtonWithStyle("もった", studentId: _studentId, () {
                speechToText.stop();
                soundEffect.setAsset("assets/sounds/good.mp3");
                soundEffect.play();
                setState(() {
                  answered = true;
                  isOnce = false;
                  isListening = false;
                });
              }),
              ElevatedButtonWithStyle("もういちど", studentId: _studentId, () {
                speechToText.stop();
                setState(() {});
              }),
              ElevatedButtonWithStyle("やめる", studentId: _studentId, () {
                // Navigator.of(context).popUntil((route) => route.isFirst);
                speechToText.stop();
                _bgmController.stop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const LoginScreen()));
              })
            ],
          )
        ];
        isVoiceFinished = false;
      } else {
        bodyMain = [
          mainContent,
          const BodyText(text: "もった？"),
          const SizedBox(
            height: 50,
          ),
        ];
      }
    } else {
      backgroundPicture =
          AssetImage('assets/images/char$_id/good_background.PNG');
      bodyMain = [const BodyText(text: "グッド！")];
      isOnce = false;

      Future.delayed(const Duration(seconds: 1), () {
        if (index == _subjects.length) {
          if (!context.mounted) return;
          soundEffect.setAsset("assets/sounds/complete.mp3");
          soundEffect.play();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => EndScreen(
                date: _date,
                studentId: _studentId,
                bgmController: _bgmController,
              ),
            ),
          );
        } else {
          setState(() {
            index++;
            answered = false;
            isListening = false;
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBarMotta(studentId: _studentId),
      body: PopScope(
        onPopInvoked: (didPop) {
          _bgmController.stop();
          characterVoice.stop();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: backgroundPicture,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/char$_id/character.gif"),
                ...bodyMain,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

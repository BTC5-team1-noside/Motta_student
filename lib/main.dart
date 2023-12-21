import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/screens/game_screen.dart';

void main() {
  const app = MyApp();
  final devicePreview = DevicePreview(builder: (_) => app);
  runApp(devicePreview);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: GameScreen(),
//     );
//   }
// }

// class GameScreen extends StatefulWidget {
//   const GameScreen({super.key});

//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   FlutterTts flutterTts = FlutterTts();
//   stt.SpeechToText speech = stt.SpeechToText();

//   List<String> items = [
//     'Item 1',
//     'Item 2',
//     'Item 3'
//   ]; // Replace with your server-fetched items
//   int currentItemIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _speakItem();
//     _playBackgroundMusic();
//   }

//   Future<void> _speakItem() async {
//     await flutterTts.speak(items[currentItemIndex]);
//   }

//   Future<void> _playBackgroundMusic() async {
//     await audioPlayer.play(AssetSource('assets/sounds/enchanted-chimes.mp3'));
//   }

//   Future<void> _stopBackgroundMusic() async {
//     await audioPlayer.stop();
//   }

//   Future<void> _listenUserResponse() async {
//     // bool available = await speech.initialize(
//     //   onStatus: (stt.SpeechToTextStatus status) {
//     //     print('onStatus: $status');
//     //   },
//     //   onError: (dynamic error) => print('onError: $error'),
//     // );

//     // if (available) {
//     //   await speech.listen(
//     //     onResult: (stt.SpeechRecognitionResult result) {
//     //       setState(() {
//     //         String userResponse = result.recognizedWords.toLowerCase();
//     //         if (userResponse.contains('준비했어')) {
//     //           _showClearScreen();
//     //         }
//     //       });
//     //     },
//     //   );
//     // }
//   }

//   Future<void> _showClearScreen() async {
//     await _stopBackgroundMusic(); // Stop background music
//     await flutterTts.speak('짜짠'); // TTS for "짜짠"
//     // Navigate to next item or show clear screen logic
//     // This is where you would handle moving to the next item or showing the clear screen in the UI
//     // Example: currentItemIndex++;
//     //          if (currentItemIndex < items.length) {
//     //            _speakItem();
//     //            _playBackgroundMusic();
//     //          } else {
//     //            // Show clear screen logic
//     //          }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('게임'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               '서버에서 받아온 아이템: ${items[currentItemIndex]}',
//               style: const TextStyle(fontSize: 18.0),
//             ),
//             ElevatedButton(
//               onPressed: _listenUserResponse,
//               child: const Text('음성으로 대답하기'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


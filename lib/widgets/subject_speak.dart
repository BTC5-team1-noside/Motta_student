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

// class FruitListScreen extends StatefulWidget {
//   const FruitListScreen({super.key});

//   @override
//   _FruitListScreenState createState() => _FruitListScreenState();
// }

// class _FruitListScreenState extends State<FruitListScreen> {
//   late FlutterTts flutterTts;
//   final List<String> fruits = [
//     "りんご",
//     "ばーなーなー",
//     "チェリーーーーーっしゅ&#xff01;",
//     "もった&#xff1f;"
//   ];

//   @override
//   void initState() {
//     super.initState();
//     flutterTts = FlutterTts();
//     flutterTts.setLanguage("ja-JP");
//     flutterTts.setPitch(1);
//   }

//   @override
//   void dispose() {
//     flutterTts.stop();
//     super.dispose();
//   }

//   Future<void> speak(String text) async {
//     await flutterTts.speak(
//       text,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: fruits.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(fruits[index]),
//           onTap: () => speak(
//             fruits[index],
//           ),
//         );
//       },
//     );
//   }
// }

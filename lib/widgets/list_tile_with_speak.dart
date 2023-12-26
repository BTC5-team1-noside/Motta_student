import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListTileWithSpeak extends StatelessWidget {
  const ListTileWithSpeak({
    super.key,
    required this.tts,
    required this.item,
  });

  final FlutterTts tts;
  final String item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          item,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () async {
          await tts.speak(item);
        });
  }
}

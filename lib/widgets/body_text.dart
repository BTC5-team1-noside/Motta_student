import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  const BodyText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}

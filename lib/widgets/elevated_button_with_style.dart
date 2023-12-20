import 'package:flutter/material.dart';

class ElevatedButtonWithStyle extends StatelessWidget {
  const ElevatedButtonWithStyle(
    this.text,
    this.func, {
    super.key,
  });
  final String text;
  final void Function() func;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 217, 66),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      onPressed: func,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}

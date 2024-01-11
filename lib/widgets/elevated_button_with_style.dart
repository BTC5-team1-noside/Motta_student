import 'package:flutter/material.dart';

List<Color> colorsArr = [
  const Color.fromARGB(180, 59, 111, 190),
  const Color.fromARGB(180, 228, 188, 109),
  const Color.fromARGB(180, 55, 172, 89),
  const Color.fromARGB(180, 61, 186, 87),
  const Color.fromARGB(180, 106, 186, 83)
];

class ElevatedButtonWithStyle extends StatelessWidget {
  const ElevatedButtonWithStyle(
    this.text,
    this.func, {
    super.key,
    required this.studentId,
  });
  final String text;
  final void Function() func;
  final int studentId;

  @override
  Widget build(BuildContext context) {
    final int colorIndex = (studentId % 5 == 0 ? 5 : studentId % 5) - 1;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: colorsArr[colorIndex],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      onPressed: func,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 35,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

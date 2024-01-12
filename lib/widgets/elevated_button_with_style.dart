import 'package:flutter/material.dart';

List<Color> colorsArr = [
  // const Color.fromARGB(180, 59, 111, 190),
  // const Color.fromARGB(180, 228, 188, 109),
  // const Color.fromARGB(180, 55, 172, 89),
  // const Color.fromARGB(180, 61, 186, 87),
  // const Color.fromARGB(180, 106, 186, 83)
  const Color.fromARGB(255, 25, 39, 114),
  const Color.fromARGB(255, 202, 133, 56),
  const Color.fromARGB(255, 219, 186, 77),
  const Color.fromARGB(255, 125, 77, 52),
  const Color.fromARGB(255, 54, 139, 50)
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

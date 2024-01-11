import "package:flutter/material.dart";

List<Color> colorsArr = [
  const Color.fromARGB(255, 59, 111, 190),
  const Color.fromARGB(255, 228, 188, 109),
  const Color.fromARGB(255, 55, 172, 89),
  const Color.fromARGB(255, 61, 186, 87),
  const Color.fromARGB(255, 106, 186, 83)
];

class AppBarMotta extends StatelessWidget implements PreferredSizeWidget {
  const AppBarMotta({
    super.key,
    required this.studentId,
  });
  final int studentId;

  @override
  Widget build(BuildContext context) {
    final int colorIndex = (studentId % 5 == 0 ? 5 : studentId % 5) - 1;
    return AppBar(
      centerTitle: true,
      title:
          // const Text(
          //   "Motta",
          //   style: TextStyle(
          //     fontSize: 35,
          //     color: Colors.white,
          //     fontWeight: FontWeight.w900,
          //   ),
          // ),
          Image.asset(
        "assets/images/Motta_logo.png",
        height: 60,
      ),
      backgroundColor: colorsArr[colorIndex],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

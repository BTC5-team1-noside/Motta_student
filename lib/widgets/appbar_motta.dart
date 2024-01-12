import "package:flutter/material.dart";

List<Color> colorsArr = [
  const Color.fromARGB(255, 25, 39, 114),
  const Color.fromARGB(255, 202, 133, 56),
  const Color.fromARGB(255, 219, 186, 77),
  const Color.fromARGB(255, 125, 77, 52),
  const Color.fromARGB(255, 54, 139, 50)
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

import "package:flutter/material.dart";

class AppBarMotta extends StatelessWidget implements PreferredSizeWidget {
  const AppBarMotta({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Center(
          child: Text(
        "Motta",
        style: TextStyle(
          fontSize: 35,
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      )),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

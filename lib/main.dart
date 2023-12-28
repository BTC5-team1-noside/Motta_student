import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:student/screens/calendar_page.dart';
import 'package:student/screens/game_screen.dart';

void main() {
  const app = MyApp();
  // //device_preview用
  // final devicePreview = DevicePreview(
  //   builder: (_) => app,
  // );
  // runApp(devicePreview);

  // simulator用
  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CalendarPage(),
      home: GameScreen(),
    );
  }
}

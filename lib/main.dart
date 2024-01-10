import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
// import 'package:student/screens/calendar_page.dart';
import 'package:student/screens/game_screen.dart';
// import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  // initializeDateFormatting().then((_) {
  //   runApp(const MyApp());
  // });

  const app = MyApp();
  //device_preview用
  final devicePreview = DevicePreview(
    builder: (_) => app,
  );
  initializeDateFormatting().then((_) {
    runApp(devicePreview);
  });
  // runApp(devicePreview);
  // // simulator用
  // runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CalendarPage(),
      home: GameScreen(),
    );
  }
}

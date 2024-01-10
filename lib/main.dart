import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:student/screens/student_login.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  const app = MyApp();
  final devicePreview = DevicePreview(
    builder: (_) => app,
  );
  initializeDateFormatting().then((_) {
    runApp(devicePreview);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

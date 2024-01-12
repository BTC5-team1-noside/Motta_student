import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:student/screens/student_login.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:just_audio/just_audio.dart';

final AudioPlayer bgmPlayer = AudioPlayer();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const app = MyApp();
  final devicePreview = DevicePreview(
    builder: (_) => app,
  );
  initializeDateFormatting().then((_) {
    runApp(devicePreview);
  });
  // initializeDateFormatting().then((_) {
  //   runApp(app);
  // });
}

@override
void dispose() {
  bgmPlayer.dispose();
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

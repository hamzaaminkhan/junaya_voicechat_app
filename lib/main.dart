import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/splash/splash_screen.dart';
import 'routes/app_routes.dart';
import 'package:junaya_voicechat_app/theme/app_theme.dart';
import 'package:junaya_voicechat_app/screens/home/home_screen.dart';

void main() {
  runApp(const JunayaApp());
}

class JunayaApp extends StatelessWidget {
  const JunayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:junaya_voicechat_app/firebase_options.dart';
import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const JunayaApp());
}

class JunayaApp extends StatelessWidget {
  const JunayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.intro,
      routes: AppRoutes.routes,
    );
  }
}
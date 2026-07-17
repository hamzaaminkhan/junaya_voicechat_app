import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/services/firebase_options.dart';
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
      title: 'JUNAID',
      theme: AppTheme.darkTheme,

      // App starts here
      initialRoute: AppRoutes.intro,

      // All routes are managed in one place
      routes: AppRoutes.routes,
    );
  }
}
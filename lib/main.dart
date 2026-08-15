import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/services/firebase_options.dart';
import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/theme/app_theme.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';

// API client
import 'package:junaya_voicechat_app/core/api/api_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================
  // FIREBASE INITIALIZATION
  // ==========================================

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ==========================================
  // BACKEND API INITIALIZATION
  // ==========================================

  ApiClient.instance.initialize();

  // ==========================================
  // START APP
  // ==========================================

  runApp(const JunayaApp());
}

class JunayaApp extends StatelessWidget {
  const JunayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'JUNAYA',

      theme: AppTheme.darkTheme,

      themeMode: ThemeMode.dark,

      initialRoute: AppRoutes.splash,

      routes: AppRoutes.routes,

      builder: (context, child) {
        return SpaceBackground(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
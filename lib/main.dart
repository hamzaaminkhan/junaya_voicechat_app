import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const JunayaApp());
}

class JunayaApp extends StatelessWidget {
  const JunayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.intro,
      routes: AppRoutes.routes,
    );
  }
}
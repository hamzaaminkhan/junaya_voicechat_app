import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:junaya_voicechat_app/services/firebase_options.dart';
import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/theme/app_theme.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';


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


      debugShowCheckedModeBanner:false,


      title:'JUNAYA',



      theme:
      AppTheme.darkTheme,



      themeMode:
      ThemeMode.dark,



      initialRoute:
      AppRoutes.intro,



      routes:
      AppRoutes.routes,

      builder: (context, child) {
        return SpaceBackground(
          child: child ?? const SizedBox.shrink(),
        );
      },

    );


  }


}
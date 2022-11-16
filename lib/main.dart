import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/forms/container_user_main.dart';
import 'package:fluttersupabase/pages_user_main/user_main.dart';
import 'package:fluttersupabase/pages_user_main/user_text_to_speech.dart';
import 'package:fluttersupabase/pages_user_main/user_translate.dart';
import 'package:fluttersupabase/pages_user_main/user_write_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'Herramientas de texto',
      theme: themeSelect(),
      initialRoute: '/main',
      routes: <String, WidgetBuilder>{
        '/main': (context) => const ContainerUserMain(),
      },
    );
  }
}

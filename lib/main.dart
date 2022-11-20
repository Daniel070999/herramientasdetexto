import 'package:flutter/material.dart';
import 'package:fluttersupabase/admob/ad.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
    //cargar los anuncios
    adBannerMenuPrincipal.load();
    adBannerListNotas.load();
    adBannerNewNote.load();
    adBannerQR.load();
    adBannerTraductor.load();
    adBannerImageText.load();
    adBannerSpeechToText.load();
    adBannerTextToSpeech.load();
    adBannerPDF.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'Herramientas de texto',
      theme: themeSelect().copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder()
          })),
      initialRoute: '/main',
      routes: <String, WidgetBuilder>{
        '/main': (context) => const ContainerUserMain(),
      },
    );
  }
}

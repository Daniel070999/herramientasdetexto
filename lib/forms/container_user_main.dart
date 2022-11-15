import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContainerUserMain extends StatefulWidget {
  const ContainerUserMain({super.key});

  @override
  State<ContainerUserMain> createState() => _ContainerUserMainState();
}

class _ContainerUserMainState extends State<ContainerUserMain> {
  late bool animationState = true;

  Future<void> _savePreferencesAnimation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animation', animationState);
  }

  Future<void> _savePreferencesTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', theme);
  }

  Future<void> _readPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    bool? animationSave = prefs.getBool('animation');
    bool? themeSave = prefs.getBool('theme');
    if (animationSave != null) {
      setState(() {
        animationState = animationSave;
      });
    }
    if (themeSave != null) {
      setState(() {
        theme = themeSave;
      });
    }
  }

  @override
  void initState() {
    _readPreferences();
    super.initState();
  }

  Widget _buttonGroupUp() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 250,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                newNote(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/notes.zip',
                        repeat: animationState,
                      ),
                    ),
                    const Expanded(flex: 1, child: Text("LISTA DE NOTAS")),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 250,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                Platform.isAndroid
                    ? scannerQRANDROID(context)
                    : scannerQRIOS(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/qr.zip',
                        repeat: animationState,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "LECTOR DE CÓDIGO QR Y CÓDIGO DE BARRAS",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonGroupDown() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 250,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                translate(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/translate.zip',
                        animate: animationState,
                      ),
                    ),
                    const Expanded(flex: 1, child: Text("TRADUCTOR DE TEXTO")),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 250,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                textImage(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/imagetext.zip',
                        repeat: animationState,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "TEXTO EN IMAGEN",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonGroupDown2() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 250,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                speechToText(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/microphone.zip',
                        repeat: animationState,
                      ),
                    ),
                    const Expanded(flex: 1, child: Text("VOZ A TEXTO")),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 250,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                textToSpeech(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset('images/lottie/speaker.zip',
                          animate: animationState, fit: BoxFit.contain),
                    ),
                    const Expanded(flex: 1, child: Text("TEXTO A VOZ")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonGroupDown3() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 250,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                readPDF(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Lottie.asset('images/lottie/pdf.zip',
                            repeat: animationState, fit: BoxFit.cover),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "ABRIR PDF",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> animaciones() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.movie_filter_outlined),
              tooltip: 'Animaciones',
              onPressed: () {
                setState(() {
                  animationState = !animationState;
                });
                _savePreferencesAnimation();
              },
            ),
            IconButton(
              icon: const Icon(Icons.wb_sunny_outlined),
              tooltip: 'Modo oscuro',
              onPressed: () {
                setState(() {
                  setState(() {
                    theme = !theme;
                  });
                  _savePreferencesTheme();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next_rounded),
              tooltip: 'Acerca de la aplicación',
              onPressed: () {
                acerca(context);
              },
            ),
          ],
          title: const Text(
            'Menu principal',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: barColor(),
            ),
          ),
        ),
        body: Container(
            color: Colors.grey.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  _buttonGroupUp(),
                  _buttonGroupDown(),
                  _buttonGroupDown2(),
                  _buttonGroupDown3(),
                ],
              ),
            )),
      ),
    );
  }
}

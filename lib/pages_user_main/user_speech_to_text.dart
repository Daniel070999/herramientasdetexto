import 'package:fluttersupabase/admob/ad.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:flutter/material.dart';

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

/// An example that demonstrates the basic functionality of the
/// SpeechToText plugin for using the speech recognition capability
/// of the underlying platform.
class _SpeechToTextPageState extends State<SpeechToTextPage>
    with TickerProviderStateMixin {
  bool isListening = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  final lastWords = TextEditingController();
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  final SpeechToText speech = SpeechToText();
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  late AnimationController controller;
  late Animation colorAnimation;
  late Animation sizeAnimation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    sizeAnimation = Tween<double>(begin: 25.0, end: 150.0).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {});
    } catch (e) {
      setState(() {
        lastError = 'Reconocimiento fallido : ${e.toString()}';
      });
    }
  }

  Future _saveNote() async {
    String description = '[{"insert":"' + lastWords.text + '\\n' + '"}]';
    final note = Note(
      title: 'Voz a texto',
      description: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
    Fluttertoast.showToast(
      msg: 'Nota creada',
      backgroundColor: Colors.grey,
    );
    lastWords.clear();
  }

  Widget _buttonGroupOptions() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: sizeAnimation.value,
            width: sizeAnimation.value,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                if (lastWords.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'No hay nada para guardar',
                    backgroundColor: Colors.grey,
                  );
                } else {
                  _saveNote();
                }
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/notes.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Guardar como nota",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: sizeAnimation.value,
            width: sizeAnimation.value,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                if (lastWords.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'No hay nada para traducir',
                    backgroundColor: Colors.grey,
                  );
                } else {
                  translate(context, lastWords.text);
                }
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/translate.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text("Traducir"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: sizeAnimation.value,
            width: sizeAnimation.value,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                setState(() {
                  lastWords.clear();
                });
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/sweep.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Limpiar",
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      title: 'Herramientas de texto',
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.navigate_before),
            tooltip: 'Regresar',
          ),
          title: const Text(
            'Voz a texto',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          color: Colors.grey.withOpacity(0.2),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: PhysicalModel(
                              elevation: 10.0,
                              shadowColor: Colors.black,
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: colorContainer(),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        maxLines: 15,
                                        cursorColor: Colors.blue,
                                        keyboardType: TextInputType.multiline,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: lastWords,
                                        decoration: InputDecoration(
                                          labelText: "Texto Reconocido",
                                          labelStyle: const TextStyle(
                                              color: Colors.blue),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: const BorderSide(
                                              color: Colors.blue,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.blue, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 5.0, left: 5.0),
                            child: _buttonGroupOptions(),
                          ),
                          GestureDetector(
                            onTap: (isListening) ? null : startListening,
                            child: Center(
                                child: speech.isListening
                                    ? Lottie.asset(
                                        'images/lottie/recording.zip',
                                        animate: true,
                                        width: 300,
                                        height: 200)
                                    : Lottie.asset(
                                        'images/lottie/recording.zip',
                                        animate: false,
                                        width: 300,
                                        height: 200)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              adMob(adBannerSpeechToText, adWidgetSpeechToText),
            ],
          ),
        ),
      ),
    );
  }

  void startListening() {
    setState(() {
      isListening = true;
    });
    lastWords.clear();
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords.text = result.recognizedWords;
    });
    setState(() {
      isListening = false;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = '$status';
    });
  }
}

class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    Key? key,
    required this.lastWords,
    required this.level,
  }) : super(key: key);

  final String lastWords;
  final double level;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  lastWords,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpeechControlWidget extends StatelessWidget {
  const SpeechControlWidget(this.isListening, this.startListening, {Key? key})
      : super(key: key);

  final bool isListening;
  final void Function() startListening;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: isListening ? null : startListening,
          child: const Text('Grabar'),
        ),
      ],
    );
  }
}

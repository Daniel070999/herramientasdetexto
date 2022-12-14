import 'package:flutter/material.dart';
import 'package:fluttersupabase/admob/ad.dart';
import 'package:fluttersupabase/constants.dart';

class TextToSpeechPage extends StatefulWidget {
  String? textIn;
  TextToSpeechPage(this.textIn);
  @override
  _TextToSpeechPageState createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage>
    with TickerProviderStateMixin {
  final String defaultLanguage = 'en-US';

  TextToSpeech tts = TextToSpeech();

  String text = '';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0; // Range: 0-2

  String? language;
  String? languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String? voice;

  final textEditingControllerTS = TextEditingController();
  final listDownController = TextEditingController();

  late AnimationController controller;
  late AnimationController controllerTapListen;
  late AnimationController controllerTapSweep;
  late AnimationController controllerTapStop;
  late Animation sizeAnimation;
  late Animation sizeAnimationTapListen;
  late Animation sizeAnimationTapSweep;
  late Animation sizeAnimationTapStop;

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
    textEditingControllerTS.text = text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLanguages();
    });
    if (widget.textIn != null) {
      setState(() {
        text = widget.textIn!;
        textEditingControllerTS.text = widget.textIn!;
      });
    }
    //animacion de camara
    controllerTapListen = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    sizeAnimationTapListen =
        Tween<double>(begin: 150, end: 50.0).animate(controllerTapListen);
    controllerTapListen.addListener(() => setState(() {}));
    //animacion de galeria
    controllerTapSweep = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    controllerTapSweep.addListener(() => setState(() {}));
    sizeAnimationTapSweep =
        Tween<double>(begin: 150, end: 50.0).animate(controllerTapSweep);
    //animacion de galeria
    controllerTapStop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    controllerTapStop.addListener(() => setState(() {}));
    sizeAnimationTapStop =
        Tween<double>(begin: 150, end: 50.0).animate(controllerTapStop);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String>? displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String? defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
    } else {
      languageCode = defaultLanguage;
    }
    language = await tts.getDisplayLanguageByCode(languageCode!);

    /// get voice
    voice = await getVoiceByLang(languageCode!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> getVoiceByLang(String lang) async {
    final List<String>? voices = await tts.getVoiceByLang(languageCode!);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
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
              onTapDown: (details) {
                controllerTapListen.forward();
              },
              onTapUp: (details) {
                controllerTapListen.reverse();
              },
              onTapCancel: () {
                controllerTapListen.reverse();
              },
              onTap: () {
                if (textEditingControllerTS.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'No hay texto para escuchar',
                    backgroundColor: Colors.grey,
                  );
                } else {
                  speak();
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
                      child: Image.asset(
                        'images/speaker.png',
                        width: sizeAnimationTapListen .value,
                        height: sizeAnimationTapListen.value,
                        scale: 9.0,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text("Escuchar"),
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
              onTapDown: (details) {
                controllerTapStop.forward();
              },
              onTapUp: (details) {
                controllerTapStop.reverse();
              },
              onTapCancel: () {
                controllerTapStop.reverse();
              },
              onTap: () {
                tts.stop();
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset(
                        'images/stop.png',
                        width: sizeAnimationTapStop.value,
                        height: sizeAnimationTapStop.value,
                        scale: 7.0,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Detener",
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
              onTapDown: (details) {
                controllerTapSweep.forward();
              },
              onTapUp: (details) {
                controllerTapSweep.reverse();
              },
              onTapCancel: () {
                controllerTapSweep.reverse();
              },
              onTap: () {
                setState(() {
                  textEditingControllerTS.clear();
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
                      child: Image.asset('images/sweep.png',
                        width: sizeAnimationTapSweep.value,
                        height: sizeAnimationTapSweep.value,),
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

  Widget _listDown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: colorContainer(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            icon: const Icon(
              Icons.keyboard_double_arrow_down_rounded,
              color: Colors.lightBlue,
            ),
            barrierColor: Colors.grey.withOpacity(0.7),
            buttonPadding: const EdgeInsets.all(10.0),
            hint: const Text(
              'Seleccione un acento',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            items: languages.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            }).toList(),
            value: language,
            onChanged: (String? newValue) async {
              languageCode = await tts.getLanguageCodeByName(newValue!);
              voice = await getVoiceByLang(languageCode!);
              setState(() {
                language = newValue;
              });
            },
            buttonHeight: 40,
            itemHeight: 40,
            dropdownMaxHeight: 250,
            searchController: listDownController,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: listDownController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  hintText: 'Buscar un idioma',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return (item.value.toString().contains(searchValue));
            },
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                listDownController.clear();
              }
            },
          ),
        ),
      ),
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
            'Texto a voz',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: barColor(),
            ),
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
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              PhysicalModel(
                                elevation: 10.0,
                                shadowColor: Colors.black,
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(40.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: colorContainer()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      onChanged: (String newText) {
                                        setState(() {
                                          text = newText;
                                        });
                                      },
                                      maxLines: 15,
                                      cursorColor: Colors.blue,
                                      keyboardType: TextInputType.multiline,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: textEditingControllerTS,
                                      decoration: InputDecoration(
                                        labelText: "Ingrese un texto",
                                        labelStyle:
                                            const TextStyle(color: Colors.blue),
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
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _listDown(context),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _buttonGroupOptions(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              adMob(adBannerTextToSpeech, adWidgetTextToSpeech)
            ],
          ),
        ),
      ),
    );
  }

  bool get supportPause => defaultTargetPlatform != TargetPlatform.android;

  bool get supportResume => defaultTargetPlatform != TargetPlatform.android;

  void speak() {
    Fluttertoast.showToast(
      msg: 'Cargando audio...',
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey,
    );
    tts.setVolume(volume);
    tts.setRate(rate);
    if (languageCode != null) {
      tts.setLanguage(languageCode!);
    }
    tts.setPitch(pitch);
    tts.speak(text);
  }
}

import 'package:flutter/material.dart';
import 'package:fluttersupabase/admob/ad.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ContainerUserMain extends StatefulWidget {
  const ContainerUserMain({super.key});

  @override
  State<ContainerUserMain> createState() => _ContainerUserMainState();
}

class _ContainerUserMainState extends State<ContainerUserMain> {
  late bool animationState = true;
  late AnimateIconController controllerIcon1, controllerIcon2;

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

  List<String> images = [
    'images/lottie/notes.zip',
    'images/lottie/qr.zip',
    'images/lottie/translate.zip',
    'images/lottie/imagetext.zip',
    'images/lottie/microphone.zip',
    'images/lottie/speaker.zip',
    'images/lottie/pdf.zip',
  ];
  List<String> titles = [
    'LISTA DE NOTAS',
    'LECTOR DE CÓDIGO QR Y CÓDIGO DE BARRAS',
    'TRADUCTOR DE TEXTO',
    'TEXTO EN IMAGEN',
    'VOZ A TEXTO',
    'TEXTO A VOZ',
    'ABRIR PDF',
  ];

  Widget menu(String image, String title, int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: OpenContainer(
        closedColor: colorContainer(),
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        closedBuilder: (context, action) {
          return Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Lottie.asset(
                  image,
                  animate: animationState,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
        openBuilder: (index == 0)
            ? (context, action) {
                return const NewNote();
              }
            : (index == 1)
                ? (context, action) {
                    return const ReadQRANDROID();
                  }
                : (index == 2)
                    ? (context, action) {
                        return Translate(null);
                      }
                    : (index == 3)
                        ? (context, action) {
                            return const TextImage();
                          }
                        : (index == 4)
                            ? (context, action) {
                                return SpeechToTextPage();
                              }
                            : (index == 5)
                                ? (context, action) {
                                    return TextToSpeechPage(null);
                                  }
                                : (index == 6)
                                    ? (context, action) {
                                        return const ReadPDF();
                                      }
                                    : (context, action) {
                                        return Container();
                                      },
      ),
    );
  }

  @override
  void initState() {
    _readPreferences();
    controllerIcon1 = AnimateIconController();
    controllerIcon2 = AnimateIconController();
    super.initState();
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
          actions: <Widget>[
            AnimateIcons(
              startIcon: Icons.pause,
              endIcon: Icons.play_arrow,
              controller: controllerIcon1,
              startTooltip: 'Desactivar animaciones',
              endTooltip: 'Activar animacioens',
              onStartIconPress: () {
                setState(() {
                  animationState = false;
                });
                _savePreferencesAnimation();
                return true;
              },
              onEndIconPress: () {
                setState(() {
                  animationState = true;
                });
                _savePreferencesAnimation();
                return true;
              },
              duration: const Duration(milliseconds: 300),
              startIconColor: Colors.white,
              endIconColor: Colors.white,
              clockwise: false,
            ),
            AnimateIcons(
              startIcon: Icons.nightlight_outlined,
              endIcon: Icons.sunny,
              controller: controllerIcon2,
              startTooltip: 'Modo oscuro',
              endTooltip: 'Modo claro',
              onStartIconPress: () {
                setState(() {
                  theme = true;
                });
                _savePreferencesTheme();
                return true;
              },
              onEndIconPress: () {
                setState(() {
                  theme = false;
                });
                _savePreferencesTheme();
                return true;
              },
              duration: const Duration(milliseconds: 300),
              startIconColor: Colors.white,
              endIconColor: Colors.white,
              clockwise: false,
            ),
            IconButton(
              icon: OpenContainer(
                closedBuilder: (context, action) {
                  return const Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.grey,
                  );
                },
                openBuilder: (context, action) {
                  return const AcercaApp();
                },
              ),
              tooltip: 'Acerca de la aplicación',
              onPressed: () {},
            ),
          ],
          title: const Text(
            'Herramientas de Texto',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: barColor(),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: barColor(),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: LiveGrid.options(
                      options: options,
                      itemBuilder: (context, index, animation) {
                        return FadeTransition(
                          opacity: Tween<double>(
                            begin: 0,
                            end: 1,
                          ).animate(animation),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -0.1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: menu(images[index], titles[index], index),
                          ),
                        );
                      },
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                    ),
                  ),
                  adMob(adBannerMenuPrincipal, adWidgetMenuPrincipal),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

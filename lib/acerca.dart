import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';

class AcercaApp extends StatefulWidget {
  const AcercaApp({super.key});

  @override
  State<AcercaApp> createState() => _AcercaAppState();
}

class _AcercaAppState extends State<AcercaApp> {
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
            'Acerca de la aplicación',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          color: Colors.grey.withOpacity(0.2),
          child: Center(
            child: Padding(
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
                    color: colorContainer(),
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const Center(
                          child: Text(
                            'HERRAMIENTAS DE TEXTO',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'La aplicación cuenta con varias herramientas posibles, entre ellas están:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          '- Creación, modificación  y eliminación de notas.' +
                              '\n' +
                              '\n' +
                              '- Lector de códigos QR y códigos de barras ya sea por medio de la cámara del teléfono o por imagen de galería.' +
                              '\n' +
                              '\n' +
                              '- Creación de códigos QR con la opción de almacenar en galería.' +
                              '\n' +
                              '\n' +
                              '- Traductor de texto disponible para varios idiomas.' +
                              '\n' +
                              '\n' +
                              '- Reconocimiento de texto ya sea por medio de la cámara del teléfono o por imagen de galería.' +
                              '\n' +
                              '\n' +
                              '- Reconocimiento de voz a texto con opción de guardar como nota o traducir a otro idioma.' +
                              '\n' +
                              '\n' +
                              '- Convertir texto a voz con opción de elegir varios acentos de idiomas.' +
                              '\n' +
                              '\n' +
                              '- Reconocimiento de texto en archivos PDF con opción de traducir o escuchar.' +
                              '\n' +
                              '\n' +
                              '- Activar o desactivar las animaciones integradas en la aplicación.' +
                              '\n' +
                              '\n' +
                              '- Activar o desactivar el modo oscuro de la aplicación.',
                          style: TextStyle(fontSize: 14.0),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'En caso de encontrar fallas en la aplicación, con el propósito de evitar bajas calificaciones en la tienda de GOOGLE PLAY, por favor, enviar su comentario por correo electrónico.',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(200)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.red)),
                          ),
                          onPressed: () {
                            final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'danielixo99dev@gmail.com');
                            launchUrl(emailLaunchUri);
                          },
                          child: const Text(
                            'Enviar correo electrónico',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(200)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.green)),
                          ),
                          onPressed: () {
                            final Uri playStoreLaunchUri = Uri.parse(
                                'https://play.google.com/store/apps/developer?id=Daniel+Pati%C3%B1o&hl=es&gl=US');
                            launchUrl(playStoreLaunchUri,
                                mode: LaunchMode.externalApplication);
                          },
                          child: const Text(
                            'Calificar positivamente en Google Play',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

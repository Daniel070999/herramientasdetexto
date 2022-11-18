//acerca
export 'package:url_launcher/url_launcher.dart';
//writenote
export 'package:flutter_quill/extensions.dart';
export 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
//translate
export 'package:translator/translator.dart';
//texttospeech
export 'package:dropdown_button2/dropdown_button2.dart';
export 'package:flutter/foundation.dart';
export 'package:text_to_speech/text_to_speech.dart';
//speechtotext
export 'dart:math';
export 'package:speech_to_text/speech_recognition_error.dart';
export 'package:speech_to_text/speech_recognition_result.dart';
export 'package:speech_to_text/speech_to_text.dart';
//qrios
//qrandroid
export 'package:image_gallery_saver/image_gallery_saver.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:share_plus/share_plus.dart';
//readpdf
export 'package:file_picker/file_picker.dart';
export 'package:pdf_text/pdf_text.dart';
export 'package:fluttersupabase/constants.dart';
//new note
export 'dart:async';
export 'dart:convert';
export 'package:fluttersupabase/note.dart';
export 'package:fluttersupabase/notes_db.dart';
export 'package:fluttersupabase/pages_user_main/user_write_note.dart';
export 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
//main
export 'package:fluttersupabase/forms/container_user_main.dart';
export 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
//imagetext
export 'dart:io';
export 'package:flutter/services.dart';
export 'package:flutter/cupertino.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:image_picker/image_picker.dart';
export 'package:google_ml_kit/google_ml_kit.dart';
//containerUserMain
export 'dart:io';
export 'package:animate_icons/animate_icons.dart';
export 'package:animations/animations.dart';
export 'package:auto_animated/auto_animated.dart';
export 'package:fluttersupabase/acerca.dart';
export 'package:fluttersupabase/pages_user_main/user_image_text.dart';
export 'package:fluttersupabase/pages_user_main/user_new_note.dart';
export 'package:fluttersupabase/pages_user_main/user_read_pdf.dart';
export 'package:fluttersupabase/pages_user_main/user_read_qr_android.dart';
export 'package:fluttersupabase/pages_user_main/user_speech_to_text.dart';
export 'package:fluttersupabase/pages_user_main/user_text_to_speech.dart';
export 'package:fluttersupabase/pages_user_main/user_translate.dart';
export 'package:lottie/lottie.dart';
export 'package:shared_preferences/shared_preferences.dart';
//constans
import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:fluttersupabase/acerca.dart';
import 'package:fluttersupabase/pages_user_main/user_read_pdf.dart';
import 'package:fluttersupabase/pages_user_main/user_speech_to_text.dart';
import 'package:fluttersupabase/pages_user_main/user_image_text.dart';
import 'package:fluttersupabase/pages_user_main/user_new_note.dart';
import 'package:fluttersupabase/pages_user_main/user_read_qr_android.dart';
import 'package:fluttersupabase/pages_user_main/user_text_to_speech.dart';
import 'package:fluttersupabase/pages_user_main/user_translate.dart';
import 'package:fluttersupabase/pages_user_main/user_write_note.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

late bool theme = false;
writeNote(BuildContext context, int? id) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteNote(id),
      ));
}

acerca(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AcercaApp(),
      ));
}

readPDF(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReadPDF(),
      ));
}

speechToText(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeechToTextPage(),
      ));
}

textToSpeech(BuildContext context, String? text) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TextToSpeechPage(text),
      ));
}

newNote(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewNote(),
      ));
}


translate(BuildContext context, String? text) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Translate(text),
      ));
}

scannerQRANDROID(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReadQRANDROID(),
      ));
}

textImage(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TextImage(),
      ));
}

const options = LiveOptions(
  delay: Duration.zero,
  showItemInterval: Duration(milliseconds: 200),
  showItemDuration: Duration(milliseconds: 200),
  visibleFraction: 0.05,
  reAnimateOnVisibility: false,
);
Color menuBackgroundColor() {
  return theme ? Colors.grey.shade900 : Colors.green;
}

Color colorContainer() {
  return theme ? Colors.grey.shade300 : Colors.white;
}

Gradient barColorScreen() {
  return theme
      ? LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
          Colors.grey.shade500,
          Colors.grey.shade900,
        ])
      : LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
          Colors.blue.shade300,
          Colors.green,
        ]);
}

Gradient barColor() {
  return theme
      ? LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
          Colors.black12,
          Colors.grey.shade300,
        ])
      : LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
          Colors.green,
          Colors.blue.shade300,
        ]);
}

ThemeData themeSelect() {
  return theme
      ? ThemeData.dark().copyWith(
          textTheme: GoogleFonts.ralewayTextTheme(),
          cardColor: Colors.grey,
          primaryColorDark: Colors.green,
          primaryColor: Colors.green,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
          ),
        )
      : ThemeData.light().copyWith(
          textTheme: GoogleFonts.ralewayTextTheme(),
          cardColor: Colors.white,
          primaryColorDark: Colors.green,
          primaryColor: Colors.green,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
          ),
        );
}

//dialogo que ocupa toda la ventana
showLoaderDialog(BuildContext context, String message, String ruteLottie) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.transparent,
    content: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.grey.withOpacity(0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    Lottie.asset(
                      ruteLottie,
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

import 'package:flutter/material.dart';
import 'package:fluttersupabase/admob/ad.dart';
import 'package:fluttersupabase/constants.dart';

class ReadPDF extends StatefulWidget {
  const ReadPDF({super.key});

  @override
  State<ReadPDF> createState() => _ReadPDFState();
}

class _ReadPDFState extends State<ReadPDF> with TickerProviderStateMixin {
  final _textInput = TextEditingController();
  PDFDoc? _pdfDoc;
  late AnimationController controller;
  late AnimationController controllerTapPDF;
  late Animation sizeAnimation;
  late Animation sizeAnimationTapPDF;
  @override
  void initState() {
    super.initState();
    //animacion de galeria
    controllerTapPDF = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    controllerTapPDF.addListener(() => setState(() {}));
    sizeAnimationTapPDF =
        Tween<double>(begin: 150, end: 50.0).animate(controllerTapPDF);
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    sizeAnimation = Tween<double>(begin: 25.0, end: 150.0).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  Future _pickPDFText(BuildContext context) async {
    try {
      var filePickerResult = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

      if (filePickerResult != null) {
        _textInput.text = 'Cargando PDF...';
        _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);

        setState(() {});
      }
      if (_pdfDoc == null) {
        return;
      }
      String text = await _pdfDoc!.text;

      setState(() {
        _textInput.text = text;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Intenta con otro documento',
        backgroundColor: Colors.grey,
      );
    }
  }

  Widget _buttonPickPDF() {
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
                controllerTapPDF.forward();
              },
              onTapUp: (details) {
                controllerTapPDF.reverse();
              },
              onTapCancel: () {
                controllerTapPDF.reverse();
              },
              onTap: () {
                try {
                  _pickPDFText(context);
                } catch (e) {
                  Fluttertoast.showToast(msg: 'Intenta con otro documento');
                }
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('images/pdf.png',
                        width: sizeAnimationTapPDF.value,
                        height: sizeAnimationTapPDF.value,),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text("Seleccionar PDF"),
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
            'Abrir PDF',
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 80.0, left: 80.0, top: 10.0),
                            child: _buttonPickPDF(),
                          ),
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
                                        maxLines: 20,
                                        cursorColor: Colors.blue,
                                        keyboardType: TextInputType.multiline,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        controller: _textInput,
                                        decoration: InputDecoration(
                                          labelText: "Texto de PDF",
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                      const Size.fromWidth(
                                                          150)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.lightBlue),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                              ),
                                              side: MaterialStateProperty.all(
                                                  const BorderSide(
                                                      color: Colors.lightBlue)),
                                            ),
                                            onPressed: () {
                                              if (_textInput.text.isEmpty) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'No hay texto para escuchar',
                                                  backgroundColor: Colors.grey,
                                                );
                                              } else {
                                                textToSpeech(
                                                    context, _textInput.text);
                                              }
                                            },
                                            child: const Center(
                                              child: Text(
                                                'Escuchar',
                                                style: TextStyle(
                                                    color: Colors.lightBlue),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                      const Size.fromWidth(
                                                          150)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.lightBlue),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                              ),
                                              side: MaterialStateProperty.all(
                                                  const BorderSide(
                                                      color: Colors.lightBlue)),
                                            ),
                                            onPressed: () {
                                              if (_textInput.text.isEmpty) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'No hay texto para traducir',
                                                  backgroundColor: Colors.grey,
                                                );
                                              } else {
                                                translate(
                                                    context, _textInput.text);
                                              }
                                            },
                                            child: const Center(
                                              child: Text(
                                                'Traducir',
                                                style: TextStyle(
                                                    color: Colors.lightBlue),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                      const Size.fromWidth(
                                                          100)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.lightBlue),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                              ),
                                              side: MaterialStateProperty.all(
                                                  const BorderSide(
                                                      color: Colors.lightBlue)),
                                            ),
                                            onPressed: () {
                                              if (_textInput.text.isEmpty) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'No hay nada para copiar',
                                                  backgroundColor: Colors.grey,
                                                );
                                              } else {
                                                Clipboard.setData(ClipboardData(
                                                    text: _textInput.text));
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Se copi?? al portapapeles',
                                                  backgroundColor: Colors.grey,
                                                );
                                              }
                                            },
                                            child: const Center(
                                              child: Text(
                                                'Copiar',
                                                style: TextStyle(
                                                    color: Colors.lightBlue),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                      const Size.fromWidth(
                                                          100)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.lightBlue),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                              ),
                                              side: MaterialStateProperty.all(
                                                  const BorderSide(
                                                      color: Colors.lightBlue)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _textInput.clear();
                                              });
                                            },
                                            child: const Center(
                                                child: Text(
                                              'Limpiar',
                                              style: TextStyle(
                                                  color: Colors.lightBlue),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              adMob(adBannerPDF, adWidgetPDF)
            ],
          ),
        ),
      ),
    );
  }
}

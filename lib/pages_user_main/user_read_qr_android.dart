import 'package:fluttersupabase/admob/ad.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:fluttersupabase/constants.dart';
import 'package:flutter/material.dart';

class ReadQRANDROID extends StatefulWidget {
  const ReadQRANDROID({super.key});

  @override
  State<ReadQRANDROID> createState() => _ReadQRANDROIDState();
}

class _ReadQRANDROIDState extends State<ReadQRANDROID>
    with TickerProviderStateMixin {
  Uint8List bytes = Uint8List(0);
  late TextEditingController _inputController;
  late TextEditingController _outputController;
  late AnimationController controller;
  late Animation colorAnimation;
  late Animation sizeAnimation;

  @override
  initState() {
    super.initState();
    _inputController = TextEditingController();
    _outputController = TextEditingController();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    sizeAnimation = Tween<double>(begin: 25.0, end: 150.0).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
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
            'Códigos QR y Códigos de barras',
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
                child: Builder(
                  builder: (BuildContext context) {
                    return ListView(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 50.0, left: 50.0, top: 25.0),
                              child: _buttonGroupUp(),
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
                                      color: colorContainer()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          maxLines: 3,
                                          cursorColor: Colors.blue,
                                          keyboardType: TextInputType.multiline,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          controller: _outputController,
                                          decoration: InputDecoration(
                                            labelText: "Texto escaneado",
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
                                                  color: Colors.blue,
                                                  width: 2.0),
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
                                                            100)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.lightBlue),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                ),
                                                side: MaterialStateProperty.all(
                                                    const BorderSide(
                                                        color:
                                                            Colors.lightBlue)),
                                              ),
                                              onPressed: () {
                                                if (_outputController
                                                    .text.isEmpty) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'No hay nada para copiar',
                                                    backgroundColor:
                                                        Colors.grey,
                                                  );
                                                } else {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text:
                                                              _outputController
                                                                  .text));
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'Se copió al portapapeles',
                                                    backgroundColor:
                                                        Colors.grey,
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
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                ),
                                                side: MaterialStateProperty.all(
                                                    const BorderSide(
                                                        color:
                                                            Colors.lightBlue)),
                                              ),
                                              onPressed: () {
                                                if (_outputController
                                                    .text.isEmpty) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'No hay nada para compartir',
                                                    backgroundColor:
                                                        Colors.grey,
                                                  );
                                                } else {
                                                  Share.share(
                                                      _outputController.text);
                                                }
                                              },
                                              child: const Center(
                                                child: Text(
                                                  'Compartir',
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
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                ),
                                                side: MaterialStateProperty.all(
                                                    const BorderSide(
                                                        color:
                                                            Colors.lightBlue)),
                                              ),
                                              onPressed: () {
                                                _outputController.clear();
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
                            const SizedBox(
                              height: 20.0,
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
                                      color: colorContainer()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          '¿Desea crear un código QR?',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'Ingrese información en el siguiente cuadro de texto y luego genere el código',
                                          textAlign: TextAlign.justify,
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            if (value.toString().isEmpty) {
                                              return 'Este campo no puede estar vacío';
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (value) {
                                            _generateBarCode(value, context);
                                          },
                                          maxLines: 3,
                                          cursorColor: Colors.blue,
                                          keyboardType: TextInputType.multiline,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          controller: _inputController,
                                          decoration: InputDecoration(
                                            labelText:
                                                "Texto para convertir a código QR",
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
                                                  color: Colors.blue,
                                                  width: 2.0),
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
                              padding: const EdgeInsets.only(
                                  right: 125.0, left: 125.0, top: 5.0),
                              child: _buttonGroupDown(),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              adMob(adBannerQR, adWidgetQR),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 350,
                child: bytes.isEmpty
                    ? const Text(
                        'Sin código',
                      )
                    : Image.memory(bytes),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightGreen),
                            overlayColor: MaterialStateProperty.all(
                                Colors.lightGreen.shade200),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await ImageGallerySaver.saveImage(this.bytes);
                              if (mounted) {
                                Fluttertoast.showToast(
                                  msg: 'Se guardó en la galería',
                                  backgroundColor: Colors.grey,
                                );
                                Navigator.pop(context);
                                _inputController.clear();
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: 'No se pudo guardar',
                                backgroundColor: Colors.grey,
                              );
                            }
                          },
                          child: const Center(
                              child: Text(
                            'Guardar',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                            overlayColor: MaterialStateProperty.all(
                                Colors.lightGreen.shade200),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              this.bytes = Uint8List(0);
                              Navigator.pop(context);
                              _inputController.clear();
                            });
                          },
                          child: const Center(
                              child: Text(
                            '    Salir    ',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonGroupUp() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: sizeAnimation.value,
            width: sizeAnimation.value,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: _scan,
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/scanPhone.png'),
                    ),
                    const Expanded(flex: 1, child: Text("Escanear")),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: sizeAnimation.value,
            width: sizeAnimation.value,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: _scanPhoto,
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/galleryPicture.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Seleccionar una imagen",
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
            height: sizeAnimation.value,
            width: sizeAnimation.value,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                _generateBarCode(_inputController.text, context);
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('images/createQR.png'),
                      ),
                    ),
                    const Expanded(flex: 1, child: Text("Generar QR")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('No se escaneo.');
    } else {
      _outputController.text = barcode;
    }
  }

  Future _scanPhoto() async {
    try {
      await Permission.storage.request();
      String barcode = await scanner.scanPhoto();
      _outputController.text = barcode;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Intente con otro código',
        backgroundColor: Colors.grey,
      );
    }
  }

  Future _generateBarCode(String inputCode, BuildContext context) async {
    if (inputCode.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No hay información para crear QR',
        backgroundColor: Colors.grey,
      );
    } else {
      Uint8List result = await scanner.generateBarCode(inputCode);
      setState(() {
        bytes = result;
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            transitionAnimationController: AnimationController(
                vsync: this, duration: const Duration(milliseconds: 400)),
            builder: (BuildContext context) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    )),
                padding: const EdgeInsets.all(30.0),
                height: 600,
                child: _qrCodeWidget(bytes, context),
              );
            });
      });
    }
  }
}

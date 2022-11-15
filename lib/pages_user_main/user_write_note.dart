import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/note.dart';
import 'package:fluttersupabase/notes_db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

enum _SelectionType {
  none,
  word,
}

class WriteNote extends StatefulWidget {
  @override
  _WriteNoteState createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {
  QuillController? _controllerDescription;
  final _titleController = TextEditingController();
  final _titleValidate = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;
  bool stateToolbar = true;
  bool updateNote = false;

  @override
  void dispose() {
    _selectAllTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
  }

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString(isDesktop()
          ? 'assets/sample_data_nomedia.json'
          : 'assets/sample_data.json');
      final doc = Document.fromJson(jsonDecode(result));
      setState(() {
        _controllerDescription = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    } catch (error) {
      final doc = Document()..insert(0, '');
      setState(() {
        _controllerDescription = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controllerDescription == null) {
      return const Scaffold(body: Center(child: Text('Cargando...')));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notas',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
          actions: [
            Row(
              children: [
                const Text('Herramientas'),
                Switch(
                  value: stateToolbar,
                  onChanged: (value) {
                    setState(() {
                      stateToolbar = value;
                    });
                  },
                )
              ],
            ),
          ],
        ),
        body: Container(
            color: Colors.grey.withOpacity(0.2),
            child: _buildWelcomeEditor(context)),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Guardar'),
          icon: const Icon(Icons.save_outlined),
          onPressed: () async {
            addNote();
            /*if (_titleValidate.currentState!.validate()) {
              final txt = jsonEncode(
                _controllerDescription?.document.toDelta().toJson());
              Fluttertoast.showToast(
                msg: _titleController.text + "\n" + txt.toString());
              setState(() {
               updateNote = false;
              });
            }*/
          },
        ),
      ),
    );
  }

  Future addNote() async {
    final note = Note(
      title: 'title',
      isImportant: true,
      number: 1,
      description: 'asd',
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    Widget titleNote = Form(
      key: _titleValidate,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            updateNote = true;
          });
        },
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'Este campo no puede estar vacío';
          }
          return null;
        },
        controller: _titleController,
        maxLines: 1,
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "Título",
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
    Widget quillEditor = MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Container(
        height: 500,
        child: QuillEditor(
          locale: const Locale('es'),
          controller: _controllerDescription!,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: _focusNode,
          autoFocus: false,
          readOnly: false,
          placeholder: 'Agrege su nueva nota',
          enableSelectionToolbar: isMobile(),
          expands: false,
          padding: EdgeInsets.zero,
          onImagePaste: _onImagePaste,
          embedBuilders: [
            ...FlutterQuillEmbeds.builders(),
          ],
        ),
      ),
    );
    var toolbar = QuillToolbar.basic(
      locale: const Locale('es'),
      controller: _controllerDescription!,
      embedButtons: FlutterQuillEmbeds.buttons(
        onImagePickCallback: _onImagePickCallback,
        onVideoPickCallback: _onVideoPickCallback,
        mediaPickSettingSelector: _selectMediaPickSetting,
        cameraPickSettingSelector: _selectCameraPickSetting,
      ),
      showAlignmentButtons: true,
      afterButtonPressed: _focusNode.requestFocus,
    );

    return ListView(
      children: [
        Column(
          children: [
            stateToolbar ? Container(child: toolbar) : Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: colorContainer(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      titleNote,
                      const SizedBox(
                        height: 10.0,
                      ),
                      quillEditor,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<String> _onImagePickCallback(File file) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  Future<String?> _webImagePickImpl(
      OnImagePickCallback onImagePickCallback) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    final fileName = result.files.first.name;
    final file = File(fileName);

    return onImagePickCallback(file);
  }

  Future<String> _onVideoPickCallback(File file) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        icon: const Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Galeria',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () =>
                            Navigator.pop(ctx, MediaPickSetting.Gallery),
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.link,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Enlace',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () =>
                            Navigator.pop(ctx, MediaPickSetting.Link),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Future<MediaPickSetting?> _selectCameraPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Foto',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () =>
                              Navigator.pop(ctx, MediaPickSetting.Camera),
                        ),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.video_call_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Video',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () =>
                              Navigator.pop(ctx, MediaPickSetting.Video),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      );

  Future<String> _onImagePaste(Uint8List imageBytes) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
            '${appDocDir.path}/${basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);
    return file.path.toString();
  }
}

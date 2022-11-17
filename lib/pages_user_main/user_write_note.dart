// ignore_for_file: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// ignore: unused_import
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttersupabase/constants.dart';

enum _SelectionType {
  none,
  word,
}

class WriteNote extends StatefulWidget {
  int? idNote;
  WriteNote(this.idNote);
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
  bool noteUpdating = false;
  bool saveNote = false;
  Note? note;

  @override
  void dispose() {
    _selectAllTimer?.cancel();
    super.dispose();
    if (widget.idNote != null) {
      updateNote();
    } else {
      if (_titleController.text.isNotEmpty && saveNote != false) {
        addNote();
      }
    }
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

  Future<void> _loadNote() async {
    int id = widget.idNote as int;
    note = await NotesDatabase.instance.readNote(id);
    var descriptionSave = jsonDecode(note!.description);
    setState(() {
      _titleController.text = note!.title;
      _controllerDescription = QuillController(
        document: Document.fromJson(descriptionSave),
        selection: const TextSelection.collapsed(offset: 0),
      );
      noteUpdating = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
    if (widget.idNote != null) {
      _loadNote();
    }
  }

  Widget _showAnimateOnBackPress(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning_amber_rounded,
        size: 50.0,
      ),
      iconColor: Colors.red,
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Center(
              child: Text(
                '¿Salir sin guardar?',
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.red),
          ),
          child: const Text(
            'Salir',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              saveNote = false;
            });
            Navigator.pop(this.context);
            Navigator.pop(context);
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.grey),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _onBackPress() {
    showGeneralDialog(
      context: this.context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _showAnimateOnBackPress(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controllerDescription == null) {
      return const Scaffold(body: Center(child: Text('Cargando...')));
    }

    return WillPopScope(
      onWillPop: () async {
        if (saveNote == true) {
          _onBackPress();
        }
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeSelect(),
        title: 'Herramientas de texto',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (saveNote == true && noteUpdating == false) {
                  _onBackPress();
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.navigate_before),
              tooltip: 'Regresar',
            ),
            title: Text(
              noteUpdating ? 'Actualizando nota' : 'Nueva nota',
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
          floatingActionButton: noteUpdating
              ? null
              : FloatingActionButton.extended(
                  label: const Text('Guardar'),
                  icon: const Icon(Icons.save_outlined),
                  onPressed: () {
                    if (_titleValidate.currentState!.validate()) {
                      addNote();
                      Fluttertoast.showToast(msg: 'Nota creada');
                      Navigator.pop(context);
                      setState(() {
                        _titleController.clear();
                        _controllerDescription?.clear();
                      });
                    }
                  },
                ),
        ),
      ),
    );
  }

  Future addNote() async {
    final description =
        jsonEncode(_controllerDescription?.document.toDelta().toJson());
    final note = Note(
      title: _titleController.text,
      description: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
  }

  Future updateNote() async {
    final description =
        jsonEncode(_controllerDescription?.document.toDelta().toJson());
    final noteUpdate = note!.copy(
      isImportant: null,
      number: null,
      title: _titleController.text,
      description: description,
    );

    await NotesDatabase.instance.update(noteUpdate);
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    Widget titleNote = Form(
      key: _titleValidate,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            saveNote = true;
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
        decoration: const InputDecoration(
          hintText: 'Título',
          labelStyle: TextStyle(color: Colors.black),
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

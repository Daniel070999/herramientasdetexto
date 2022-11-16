import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttersupabase/note.dart';
import 'package:fluttersupabase/notes_db.dart';
import 'package:fluttersupabase/pages_user_main/user_write_note.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:share_plus/share_plus.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _validateTitle = GlobalKey<FormState>();
  final _validateNoteUpdate = GlobalKey<FormState>();
  String _newTitleUpdate = '';
  String _newDescriptionUpdate = '';
  String _newIdNoteUpdate = '';
  bool _loadingNotes = false;
  bool _titleUpdate = false;
  bool _descriptionUpdate = false;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  late List<Note> notes = [];
  Future<void> _saveNote(BuildContext context) async {
    //almacenar internamente
  }

  Future<void> _deleteNote(BuildContext context, int idUpdate) async {
    await NotesDatabase.instance.delete(idUpdate);
    if (mounted) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Nota eliminada');
      refreshNotes();
    }
  }

  Future<void> _confirmNoUpdate(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning,
            size: 50.0,
          ),
          iconColor: Colors.red,
          actionsAlignment: MainAxisAlignment.center,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text(
              '¿Esta seguro que desea salir sin guardar los cambios?'),
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              child: const Text(
                'Salir sin guardar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _titleUpdate = false;
                _descriptionUpdate = false;
              },
            ),
          ],
        );
      },
    );
  }

  void _viewDeleteNote(String titleUpdate, int idUpdate) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _showAnimateDeleteNote(ctx, titleUpdate, idUpdate),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  Widget _showAnimateDeleteNote(
      BuildContext context, String titleUpdate, int idUpdate) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning_rounded,
        size: 50.0,
      ),
      iconColor: Colors.red,
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Center(
              child: Text(
                '¿Desea eliminar la nota?',
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(titleUpdate),
            )
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.red),
          ),
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _deleteNote(context, idUpdate);
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

  Future<void> _viewNote(BuildContext context, String titleUpdate,
      String descriptionUpdate, String idUpdate) async {}

//ya no se usa
  Future showButtomNewNote() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.indigo.withOpacity(1),
                    Colors.teal.withOpacity(0.5),
                    Colors.transparent,
                  ]),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              )),
          padding: const EdgeInsets.all(30.0),
          height: 700,
          child: Form(
            key: _validateTitle,
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 1,
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Título",
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    maxLines: 10,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.white),
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descripción",
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(Size.fromWidth(150)),
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
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.white)),
                        ),
                        onPressed: () {
                          if (_validateTitle.currentState!.validate()) {
                            _saveNote(context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Center(
                                child: Text(
                              'Guardar',
                              style: TextStyle(color: Colors.white),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      OutlinedButton(
                        style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(Size.fromWidth(150)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          overlayColor:
                              MaterialStateProperty.all(Colors.red.shade200),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _titleController.clear();
                          _descriptionController.clear();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Center(
                              child: Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future refreshNotes() async {
    setState(() => _loadingNotes = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => _loadingNotes = false);
  }

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.navigate_before),
            ),
          ),
          title: const Text(
            'Notas',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
            color: Colors.grey.withOpacity(0.2),
            child: (_loadingNotes == false)
                ? (notes.isEmpty)
                    ? Center(
                        child: RefreshIndicator(
                          onRefresh: refreshNotes,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('No tiene notas creadas'),
                                  Lottie.asset('images/lottie/empty.zip',
                                      repeat: false),
                                  const Divider(
                                      height: 50,
                                      color: Colors.grey,
                                      thickness: 1,
                                      endIndent: 20,
                                      indent: 20),
                                  const Text(
                                      'Puede crear su primera nota en esta parte'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Lottie.asset(
                                        'images/lottie/arrowdown.zip',
                                        height: 150,
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: refreshNotes,
                        child: ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                    child: ListTile(
                                      onLongPress: () {
                                        _viewDeleteNote(
                                            note.title, note.id!.toInt());
                                      },
                                      onTap: () {
                                        int id = note.id!.toInt();
                                        writeNote(context, id);
                                      },
                                      minVerticalPadding: 10,
                                      title: Text(
                                        note.title,
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                      trailing: Text(
                                        'Fecha: ' +
                                            note.createdTime
                                                .toIso8601String()
                                                .replaceAll(
                                                    RegExp('T'), '\nHora: ')
                                                .replaceRange(25, null, ''),
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                : Center(
                    child: Lottie.asset('images/lottie/searching.zip',
                        width: 300, height: 300, fit: BoxFit.fill),
                  )),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          overlayStyle: ExpandableFabOverlayStyle(
            blur: 0,
          ),
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                writeNote(context, null);
              },
              icon: const Icon(Icons.text_snippet_outlined),
              label: const Text('Escribir'),
            ),
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                speechToText(context);
              },
              icon: const Icon(Icons.keyboard_voice_outlined),
              label: const Text('Hablar'),
            ),
          ],
        ),
      ),
    );
  }
}

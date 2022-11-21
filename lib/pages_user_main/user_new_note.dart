import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttersupabase/admob/ad.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:path_provider/path_provider.dart';

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
  late AnimateIconController controllerIcon;
  late List<List<dynamic>> employeeData;
  List<PlatformFile>? _paths;
  String? _extension = "csv";
  FileType _pickingType = FileType.custom;

  Future<void> _deleteNote(BuildContext context, int idUpdate) async {
    await NotesDatabase.instance.delete(idUpdate);
    if (mounted) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Nota eliminada',
        backgroundColor: Colors.grey,
      );
      refreshNotes();
    }
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

  Future refreshNotes() async {
    setState(() => _loadingNotes = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => _loadingNotes = false);
  }

  @override
  void initState() {
    refreshNotes();
    controllerIcon = AnimateIconController();
    employeeData = List<List<dynamic>>.empty(growable: true);
    super.initState();
  }

  exportNotes(BuildContext _) async {
    late List<Note> notesRead = [];
    notesRead = await NotesDatabase.instance.readAllNotes();
    if (notesRead.isEmpty) {
      Fluttertoast.showToast(
          msg: 'No tiene notas para exportar', backgroundColor: Colors.grey);
    } else {
      if (await Permission.storage.request().isGranted) {
        String dir = (await getExternalStorageDirectory())!.path +
            "/copia_de_seguridad_Notas.csv";
        String file = "$dir";
        File f = File(file);
        employeeData.clear();
        for (var i = 0; i < notesRead.length; i++) {
          List<dynamic> row = List.empty(growable: true);
          row.add(notesRead[i].title);
          row.add(notesRead[i].description);
          row.add(notesRead[i].createdTime);
          employeeData.add(row);
        }

        String csv = const ListToCsvConverter().convert(employeeData);
        f.writeAsString(csv);
        viewExportNotes(_, f);
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
      }
    }
  }

  importNotes(BuildContext _) async {
    late List<Note> notesRead = [];
    notesRead = await NotesDatabase.instance.readAllNotes();
    if (notesRead.isNotEmpty) {
      Fluttertoast.showToast(
          msg: 'Usted ya tiene notas creadas', backgroundColor: Colors.grey);
    } else {
      openFileExplorer();
    }
  }

  openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
      print(_paths);
      print("File path ${_paths![0]}");
      print(_paths!.first.extension);
    });
  }

  openFile(filepath) async {
    File f = new File(filepath);
    print("CSV to List");
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    print(fields);
    setState(() {
      employeeData.clear();
      employeeData = fields;
      reloadNotesImport();
    });
  }

  reloadNotesImport() async {
    try {
      for (var i = 0; i < employeeData.length; i++) {
        // QuillController? controllerDescription;
        //controllerDescription = employeeData[i][1];
        //final description = jsonEncode(controllerDescription?.document.toDelta().toJson());
        final note = Note(
          title: employeeData[i][0],
          description: employeeData[i][1],
          createdTime: DateTime.parse(employeeData[i][2]),
        );
        await NotesDatabase.instance.create(note);
      }
      setState(() {
        refreshNotes();
      });
      Fluttertoast.showToast(
          msg: 'Notas importadas', backgroundColor: Colors.grey);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'Algo salió mal', backgroundColor: Colors.grey);
    }
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
          actions: [
            AnimateIcons(
              startIcon: Icons.refresh_rounded,
              endIcon: Icons.refresh_rounded,
              controller: controllerIcon,
              startTooltip: 'Recargar',
              endTooltip: 'Recargar',
              onStartIconPress: () {
                setState(() {
                  refreshNotes();
                });
                return true;
              },
              onEndIconPress: () {
                setState(() {
                  refreshNotes();
                });
                return true;
              },
              duration: const Duration(milliseconds: 600),
              startIconColor: Colors.white,
              endIconColor: Colors.white,
              clockwise: false,
            ),
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return const [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Exportar Notas"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Importar Notas"),
                ),
              ];
            }, onSelected: (value) async {
              if (value == 0) {
                exportNotes(context);
              } else if (value == 1) {
                importNotes(context);
              }
            }),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.navigate_before),
            tooltip: 'Regresar',
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
          child: Column(
            children: [
              Expanded(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                        : LiveList.options(
                            options: options,
                            itemCount: notes.length,
                            itemBuilder: (context, index, animation) {
                              final note = notes[index];
                              int id = note.id!.toInt();
                              return FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0,
                                  end: 1,
                                ).animate(animation),
                                // And slide transition
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10.0, right: 10.0),
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, -0.1),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    // Paste you Widget
                                    child: PhysicalModel(
                                      elevation: 5.0,
                                      shadowColor: Colors.black,
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(40.0),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colorContainer(),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        child: OpenContainer(
                                          closedShape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(25.0),
                                            ),
                                          ),
                                          transitionType:
                                              ContainerTransitionType
                                                  .fadeThrough,
                                          closedBuilder: (BuildContext _,
                                              VoidCallback openContainer) {
                                            return ListTile(
                                              onLongPress: () {
                                                _viewDeleteNote(note.title,
                                                    note.id!.toInt());
                                              },
                                              onTap: openContainer,
                                              title: Text(
                                                note.title,
                                                style: const TextStyle(
                                                    fontSize: 18.0),
                                              ),
                                              trailing: Text(
                                                'Fecha: ' +
                                                    note.createdTime
                                                        .toIso8601String()
                                                        .replaceAll(RegExp('T'),
                                                            '\nHora: ')
                                                        .replaceRange(
                                                            25, null, ''),
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                              ),
                                            );
                                          },
                                          openBuilder: (BuildContext _,
                                              VoidCallback __) {
                                            return WriteNote(id);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                    : Center(
                        child: Lottie.asset('images/lottie/searching.zip',
                            width: 300, height: 300, fit: BoxFit.fill),
                      ),
              ),
              adMob(adBannerListNotas, adWidgetListaNotas),
            ],
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          afterClose: refreshNotes,
          backgroundColor: Colors.lightBlue,
          overlayStyle: ExpandableFabOverlayStyle(
            blur: 0,
          ),
          children: [
            OpenContainer(
              closedColor: Colors.lightGreen,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return FloatingActionButton.extended(
                  onPressed: openContainer,
                  icon: const Icon(Icons.text_snippet_outlined),
                  label: const Text('Escribir'),
                  backgroundColor: Colors.lightGreen,
                );
              },
              openBuilder: (BuildContext _, VoidCallback __) {
                return WriteNote(null);
              },
            ),
            OpenContainer(
              closedColor: Colors.lightGreen,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              closedBuilder: (context, VoidCallback openContainer) {
                return FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: openContainer,
                  icon: const Icon(Icons.keyboard_voice_outlined),
                  label: const Text('Hablar'),
                  backgroundColor: Colors.lightGreen,
                );
              },
              openBuilder: (context, VoidCallback __) {
                return SpeechToTextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}

viewExportNotes(BuildContext _, File file) {
  showGeneralDialog(
    context: _,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.fastOutSlowIn.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: showAnimateExportNotes(ctx, file),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

Widget showAnimateExportNotes(BuildContext context, File file) {
  return AlertDialog(
    icon: const Icon(
      Icons.check_circle_outline,
      size: 80.0,
    ),
    iconColor: Colors.lightGreen,
    actionsAlignment: MainAxisAlignment.center,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          const Center(
            child: Text(
              'Notas exportadas',
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Por favor, evite modificar el documento generado.\nLas imágenes y videos no se podrán ver ya que son almacenadas internamente en el dispositivo en el cual fue creada la nota.\nLas notas fueron exportadas en:',
                  textAlign: TextAlign.justify,
                ),
                const Divider(
                  height: 10,
                  color: Colors.black,
                ),
                Text(
                  file.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    ),
    actions: <Widget>[
      const SizedBox(
        height: 20.0,
      ),
      ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
        ),
        child: const Text(
          'Aceptar',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

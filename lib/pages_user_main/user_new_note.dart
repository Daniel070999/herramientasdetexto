import 'package:flutter/material.dart';
import 'package:fluttersupabase/admob/ad.dart';
import 'package:fluttersupabase/constants.dart';

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

  Future refreshNotes() async {
    setState(() => _loadingNotes = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => _loadingNotes = false);
  }

  @override
  void initState() {
    refreshNotes();
    controllerIcon = AnimateIconController();
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
                            // Like GridView.builder, but also includes animation property
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
                                      begin: Offset(0, -0.1),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    // Paste you Widget
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
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
                                            ContainerTransitionType.fadeThrough,
                                        closedBuilder: (BuildContext _,
                                            VoidCallback openContainer) {
                                          return ListTile(
                                            onLongPress: () {
                                              _viewDeleteNote(
                                                  note.title, note.id!.toInt());
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
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          );
                                        },
                                        openBuilder:
                                            (BuildContext _, VoidCallback __) {
                                          return WriteNote(id);
                                        },
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

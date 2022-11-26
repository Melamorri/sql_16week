import 'package:flutter/material.dart';
import 'package:sql_16week/helpers/note.dart';
import 'package:sql_16week/helpers/notes_repository.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _notesRepo = NotesRepository();
  // late var _notes = _notesRepo.notes;
  late var _notes = <Note>[];

  @override
  void initState() {
    super.initState();
    _notesRepo
        .initDB()
        .whenComplete(() => setState(() => _notes = _notesRepo.notes));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(
            _notes[i].name,
          ),
          subtitle: Text(
            _notes[i].description,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _updateNoteDialog(_notes[i]);
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                  onPressed: (() {
                    _notesRepo.deleteNote(_notes[i]);
                    setState(() {
                      _notes = _notesRepo.notes;
                    });
                  }),
                  icon: Icon(Icons.delete_sharp))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _showDialog() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          final descController = TextEditingController();
          return AlertDialog(
            title: const Text('New note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await _notesRepo.addNote(
                    Note(
                        name: nameController.text,
                        description: descController.text),
                  );
                  setState(() {
                    _notes = _notesRepo.notes;
                    Navigator.pop(context);
                  });
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );

  Future _updateNoteDialog(Note note) => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          final descController = TextEditingController();
          return AlertDialog(
            title: const Text('Edit note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: note.name,
                  ),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(hintText: note.description),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final updatedNote = Note(
                      name: nameController.text,
                      description: descController.text);
                  _notesRepo.updateNote(note, updatedNote);
                  setState(() {
                    _notes = _notesRepo.notes;
                    Navigator.pop(context);
                  });
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );
}

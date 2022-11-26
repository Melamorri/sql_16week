import 'package:sql_16week/helpers/note.dart';
import 'package:sql_16week/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class NotesRepository {
  late final Store _store;
  late final Box<Note> _box;

  // final _notes = <Note>[];

  List<Note> get notes => _box.getAll();

  Future initDB() async {
    _store = await openStore();
    _box = _store.box<Note>();
  }

  Future addNote(Note note) async {
    await _box.putAsync(note);
  }

  Future deleteNote(Note note) async {
    _box.remove(note.id);
  }

  Future updateNote(note, Note updatedNote) async {
    _box.remove(note.id);
    _box.put(updatedNote);
  }
}

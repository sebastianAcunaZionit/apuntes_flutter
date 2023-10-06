import 'package:apuntes/errors/custom_error.dart';
import 'package:apuntes/entities/note.dart';
import 'package:apuntes/services/db_isar_service.dart';
import 'package:isar/isar.dart';

class NoteDatasource {
  late Future<Isar> db;

  NoteDatasource() {
    db = IsarDBService().openDB();
  }

  Future<Id> postNote(Note note) async {
    final isar = await db;
    try {
      return await isar.writeTxn(() => isar.notes.put(note));
    } on IsarError catch (e) {
      throw CustomError(e.message);
    } catch (e) {
      throw CustomError("error no controlado");
    }
  }

  Future<Note?> findNoteById(String id) async {
    final isar = await db;
    return isar.notes.filter().idEqualTo(id).findFirst();
  }

  Future<List<Note>> findNotes() async {
    final isar = await db;
    return isar.notes.where().findAll();
  }

  Future<List<Note>> findNotesToSync() async {
    final isar = await db;
    return await isar.notes
        .filter()
        .syncStateEqualTo(SyncState.pending)
        .findAll();
  }
}

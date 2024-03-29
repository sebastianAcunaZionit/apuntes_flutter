import 'package:isar/isar.dart';
import 'package:apuntes/errors/custom_error.dart';
import 'package:apuntes/entities/entities.dart';
import 'package:apuntes/services/services.dart';

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

  Future<List<Note>> findNotes({
    int offset = 0,
    int? limit,
    String? name,
  }) async {
    final isar = await db;

    FilterCondition? filterCondition;
    if (name != null) {
      filterCondition = FilterCondition.contains(property: 'name', value: name);
    }

    final response = await isar.notes
        .buildQuery<Note>(limit: limit, offset: offset, filter: filterCondition)
        .findAll();

    return response;
  }

  Future<List<Note>> findNotesToSync() async {
    final isar = await db;
    return await isar.notes
        .filter()
        .syncStateEqualTo(SyncDataStatus.pending)
        .findAll();
  }
}

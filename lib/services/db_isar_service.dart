import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apuntes/entities/entities.dart';

class IsarDBService {
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.openSync([UserSchema, NoteSchema],
          inspector: true, directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }
}

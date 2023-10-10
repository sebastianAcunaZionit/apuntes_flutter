import 'package:apuntes/errors/custom_error.dart';
import 'package:apuntes/entities/user.dart';
import 'package:apuntes/services/db_isar_service.dart';
import 'package:isar/isar.dart';

class UserDatasource {
  late Future<Isar> db;

  UserDatasource() {
    db = IsarDBService().openDB();
  }

  Future<void> insertUsers(List<User> users) async {
    final isar = await db;

    try {
      List<User> usertModels = [];
      for (var user in users) {
        final exist =
            await isar.users.filter().emailEqualTo(user.email).findFirst();
        if (exist != null) {
          usertModels.add(User(
            isarId: exist.isarId,
            id: user.id,
            email: user.email,
            userName: user.userName,
            fullName: user.fullName,
          ));
        } else {
          usertModels.add(user);
        }
      }

      await isar.writeTxn(() => isar.users.putAll(usertModels));
    } on IsarError catch (e) {
      throw CustomError(e.message);
    } catch (e) {
      throw CustomError("error no controlado");
    }
  }

  Future<User?> getUserById(int id) async {
    final isar = await db;
    return await isar.users.filter().idEqualTo(id).findFirst();
  }

  Future<User?> getUserByEmail(String email) async {
    final isar = await db;
    return await isar.users.filter().emailEqualTo(email).findFirst();
  }
}

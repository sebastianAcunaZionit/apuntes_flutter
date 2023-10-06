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
      await isar.writeTxn(() => isar.users.putAll(users));
    } on IsarError catch (e) {
      throw CustomError(e.message);
    } catch (e) {
      throw CustomError("error no controlado");
    }
  }

  Future<User?> getUserByEmail(String email) async {
    final isar = await db;
    return await isar.users.filter().emailEqualTo(email).findFirst();
  }
}

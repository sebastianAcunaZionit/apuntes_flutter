import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  final Id? isarId;
  final int id;
  final String email;
  final String userName;
  final String fullName;

  User({
    required this.isarId,
    required this.id,
    required this.email,
    required this.userName,
    required this.fullName,
  });
}

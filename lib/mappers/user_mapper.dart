import 'package:apuntes/entities/user.dart';

class UserMapper {
  static User mapToEntity(Map<String, dynamic> json) => User(
        isarId: null,
        id: int.tryParse(json["id_user"]) ?? 1,
        email: json["user_mail"],
        userName: json["user_mail"],
        fullName: json["nom_user"],
      );
}

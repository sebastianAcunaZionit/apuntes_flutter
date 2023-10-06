import 'package:apuntes/entities/user.dart';

class UserMapper {
  static User mapToEntity(Map<String, dynamic> json) => User(
      isarId: null,
      id: json["id_user"],
      email: json["user_mail"],
      userName: "",
      fullName: json["nom_user"]);
}

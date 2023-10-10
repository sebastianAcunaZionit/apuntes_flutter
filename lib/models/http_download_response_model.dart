import 'package:apuntes/entities/user.dart';
import 'package:apuntes/mappers/user_mapper.dart';

class HttpDownloadResponseModel {
  final List<dynamic> users;

  HttpDownloadResponseModel({required this.users});

  List<User> jsonToEntity() {
    final List<User> userList = users.map((user) {
      return UserMapper.mapToEntity(user);
    }).toList();
    return userList;
  }
}

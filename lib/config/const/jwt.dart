import 'package:apuntes/config/configs.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Jwt {
  static String sign(Map<String, dynamic> payload) {
    final jwt = JWT(payload);
    final token = jwt.sign(SecretKey(Environment.tokenKey));
    return token;
  }

  static verify(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(Environment.tokenKey));
      return {'ok': true, 'message': 'token valido', 'payload': jwt.payload};
    } on JWTExpiredException {
      return {'ok': false, 'message': 'Token expirado'};
    } on JWTException catch (e) {
      return {'ok': false, 'message': 'Error inesperado al validar token $e'};
    }
  }
}

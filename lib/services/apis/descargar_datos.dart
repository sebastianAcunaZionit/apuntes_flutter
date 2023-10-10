import 'package:apuntes/config/const/environment.dart';
import 'package:apuntes/errors/custom_error.dart';
import 'package:apuntes/models/http_download_response_model.dart';
import 'package:dio/dio.dart';

class DownloadData {
  final Dio dio = Dio(BaseOptions(baseUrl: "${Environment.apiUrl}/backend"));

  Future<HttpDownloadResponseModel> downloadData() async {
    try {
      final data = await dio.get('/lista_usuarios.php');
      final userList = data.data["usuarios"];
      print(userList);
      final response = HttpDownloadResponseModel(users: userList);
      return response;
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 404;
      switch (code) {
        case 400:
          throw CustomError(
              e.response?.data["message"] ?? "error sin capturar");
        case 404:
          throw CustomError("No se pudo encontrar el servidor de subida.");
        case 500:
          throw CustomError("Hubo un error subiendo datos al servidor");
        default:
          throw CustomError("No se pudo encontrar el servidor de subida.");
      }
    } catch (e) {
      throw CustomError("error no controlado");
    }
  }
}

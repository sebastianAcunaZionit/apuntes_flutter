import 'package:dio/dio.dart';
import 'package:apuntes/config/configs.dart';
import 'package:apuntes/errors/custom_error.dart';
import 'package:apuntes/models/models.dart';

class UploadData {
  final Dio dio = Dio(BaseOptions(baseUrl: "${Environment.apiUrl}/backend"));

  Future<HttpUploadResponseModel> uploadData(
      HttpUploadRequestModel request) async {
    try {
      final payload = request.modelToRequest();
      final data = await dio.post('/guarda_data.php', data: payload);
      final response = HttpUploadResponseModel.fromJson(data.data);
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

import 'package:apuntes/config/const/environment.dart';
import 'package:dio/dio.dart';

class DownloadData {
  final Dio dio = Dio(BaseOptions(baseUrl: "${Environment.apiUrl}/backend"));
}

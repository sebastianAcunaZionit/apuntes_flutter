import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  static String tokenKey = dotenv.get('JWT_KEY');
  static String apiUrl = dotenv.get('API_URL');
  static String apkVersion = dotenv.get('APK_VERSION');
}

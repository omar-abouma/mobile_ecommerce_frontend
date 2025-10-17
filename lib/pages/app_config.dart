import 'dart:io';

class AppConfig {
  static String get baseUrl {
    if (Platform.isAndroid) {
      // ✅ For Android Emulator
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      // ✅ For iOS Simulator
      return 'http://127.0.0.1:8000';
    } else {
      // ✅ For Web & Desktop
      return 'http://127.0.0.1:8000';
    }
  }
  
  // ✅ Auth endpoints
  static String get registerUrl => '$baseUrl/api/flutter_app/register/';
  static String get loginUrl => '$baseUrl/api/flutter_app/login/';
  static String get logoutUrl => '$baseUrl/api/flutter_app/logout/';
}
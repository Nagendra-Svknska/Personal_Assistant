import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  static Future<void> saveProvider(
      String provider) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'provider',
      provider,
    );
  }

  static Future<String> getProvider()
      async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
          'provider',
        ) ??
        'ollama';
  }

  static Future<void> saveBackendUrl(
      String url) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'backend_url',
      url,
    );
  }

  static Future<String> getBackendUrl()
      async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
          'backend_url',
        ) ??
        'http://127.0.0.1:8000';
  }
}
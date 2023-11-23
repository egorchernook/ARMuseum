import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static AppConfig? _instance;
  static late String _content;

  static Future<AppConfig> getInstance() async {
    if (_instance == null) {
      AppConfig._content = await rootBundle.loadString(
        'assets/config/config.json',
      );
    }
    return _instance!;
  }

  dynamic get(String key) {
    final json = jsonDecode(_content);
    return json[key];
  }
}

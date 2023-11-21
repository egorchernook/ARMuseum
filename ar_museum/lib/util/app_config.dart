import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal();

  static Future<dynamic> get(String key) async {
    final contents = await rootBundle.loadString(
      'assets/config/config.json',
    );
    final json = jsonDecode(contents);
    return json[key];
  }
}

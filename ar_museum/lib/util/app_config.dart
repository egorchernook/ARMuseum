import 'dart:convert';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  static String? _content;
  AppConfig._internal();

  // Please don`t use it more then once && outside main
  static void setContent(String content) {
    AppConfig._content = content;
  }

  static dynamic get(String key) {
    if(_content == null){
      return null;
    }
    final json = jsonDecode(_content!);
    return json[key];
  }
}

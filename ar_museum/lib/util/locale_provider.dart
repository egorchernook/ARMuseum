import 'package:flutter/cupertino.dart';

import '../l10n/all_locales.dart';

class LocaleProvider with ChangeNotifier {
  late Locale _locale;
  Locale get locale => _locale;
  void setLocale(Locale locale) {
    if (!AllLocales.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}
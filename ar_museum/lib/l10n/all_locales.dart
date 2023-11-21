import 'package:flutter/material.dart';

class AllLocales {
  AllLocales();

  static final all = <Locale>[
    const Locale("ru", "RU"),
    const Locale("en", "US"),
    const Locale("zn", "CN")
  ];

  static final localeName =
      Map<Locale, String>.unmodifiable(
          {
            all[0]: "Русский",
            all[1]: "English",
            all[2]: "汉语"
          });
}

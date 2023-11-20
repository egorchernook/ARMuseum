import 'package:flutter/material.dart';

class AllLocales {
  AllLocales();

  static final all = <Locale>[
    const Locale("ru", "RU"),
    const Locale("en", "US")
  ];

  static final localeName =
      Map<Locale, String>.unmodifiable(
          {
            all[0]: "Русский",
            all[1]: "English"
          });
}

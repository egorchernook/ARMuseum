import 'package:ar_museum/l10n/all_locales.dart';
import 'package:ar_museum/screens/main_qr_scan_screen_old.dart';
import 'package:ar_museum/screens/model_qr_scan_screen.dart';
import 'package:ar_museum/screens/unity_load_screen.dart';
import 'package:ar_museum/util/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/ar_screen.dart';
import 'screens/language_settings_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String appName = 'ARMuseum';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocaleProvider>(
        create: (_) => LocaleProvider(),
        builder: (context, child) {
          return MaterialApp(
            title: '$appName app',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            supportedLocales: AllLocales.all,
            locale: Provider.of<LocaleProvider>(context).locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            routes: {
              "/languageSettings": (context) => const LanguageSettingsScreen(),
              "/mainQR": (context) => const MainQRScanScreen(),
              "/modelQR": (context) => const QRScanScreen(),
              "/arScreen": (context) => const ARScreen(),
              "/unityLoad": (context) => const UnityLoadScreen()
            },
            initialRoute: "/unityLoad",
          );
        });
  }
}

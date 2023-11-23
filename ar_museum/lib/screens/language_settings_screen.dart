import 'package:ar_museum/l10n/all_locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util/locale_provider.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String? dropdownValue = AllLocales.localeName[AllLocales.all[0]];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.chooseLanguage),
          backgroundColor: Colors.lightBlue,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const Spacer(flex: 2),
              Text(AppLocalizations.of(context)!.chooseLanguage,
                  textScaleFactor: 2),
              const Spacer(),
              DropdownMenu<String>(
                initialSelection: dropdownValue,
                onSelected: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(
                      AllLocales.localeName.keys.firstWhere(
                          (locale) => AllLocales.localeName[locale] == value,
                          orElse: () => AllLocales.all[0]));
                  if (kDebugMode) {
                    print(dropdownValue);
                  }
                },
                dropdownMenuEntries: AllLocales.all
                    .map<DropdownMenuEntry<String>>((Locale locale) {
                  final value = AllLocales.localeName[locale].toString();
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              const Spacer(flex: 2),
              CupertinoButton(
                color: Colors.lightBlue,
                onPressed: () {
                  Navigator.pushNamed(context, "/mainQR");
                },
                child: Text(AppLocalizations.of(context)!.apply),
              ),
              const Spacer(flex: 3),
            ])));
  }
}

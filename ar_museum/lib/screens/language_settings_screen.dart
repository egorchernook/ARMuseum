import 'package:ar_museum/l10n/all_locales.dart';
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
    return Column(children: [
      Text(AppLocalizations.of(context)!.chooseLanguage),
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
        },
        dropdownMenuEntries:
            AllLocales.all.map<DropdownMenuEntry<String>>((Locale locale) {
          final value = AllLocales.localeName[locale].toString();
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      ),
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.lightBlueAccent,
        ),
        onPressed: () {},
        child: Text(AppLocalizations.of(context)!.apply),
      )
    ]);
  }
}

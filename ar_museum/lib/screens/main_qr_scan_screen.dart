import 'dart:convert';

import 'package:ar_museum/util/exhibition_info_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../util/app_config.dart';
import '../util/exhibition_info.dart';
import 'base_qr_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainQRScanScreen extends BaseQRScreen {
  const MainQRScanScreen({Key? key}) : super(key: key);

  @override
  State<MainQRScanScreen> createState() => _MainQRScanState();
}

class _MainQRScanState extends BaseQRScreenState<MainQRScanScreen> {
  String url =
      "http://188.232.151.86:87/test?locale=ru_RU&exhibitionId=1&museumId=1";

  @override
  Widget build(BuildContext context) {
    return super.buildQRView(
        context, _onQRViewCreated, AppLocalizations.of(context)!.mainQRText);
  }

  Future<String> _sendJSON(String url, Map<String, dynamic> json) async {
    // url = await AppConfig.get("mainQRURL");
    // final uri = Uri.http(url, '', json);
    var request = await httpClient!.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    // request. = utf8.encode(jsonEncode(json));
    var response = await request.close();

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print("Error on json sending : ${response.statusCode}");
      }
      throw Exception("Response code is not 200");
    }
    final reply = await response.transform(utf8.decoder).join();
    return reply;
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      super.controller = controller;
    });
    final subscription = controller.scannedDataStream.listen(null);
    subscription.onData((event) {
      if (event.code != null) {
        subscription.cancel();
        controller.stopCamera();

        final currentLocale = Localizations.localeOf(context);
        final localeValue =
            "${currentLocale.languageCode}_${currentLocale.countryCode!}";
        var json = jsonDecode(event.code!) as Map<String, dynamic>;

        json["locale"] = localeValue;
        if (kDebugMode) {
          print(json);
        }

        _sendJSON(url, json).then((value) {
          print(value);
          ExhibitionInfo.fromJson(jsonDecode(value));
          Navigator.pushNamed(context, "/modelQR");
        });
      }
    });
  }

  void _MOCKED_onQRViewCreated(QRViewController controller) {
    setState(() {
      super.controller = controller;
    });
    controller.stopCamera();
    var json = {"exhibitionId": 1, "museumId": 1, "locale": "ru_RU"};

    if (kDebugMode) {
      print(json);
    }

    _sendJSON(url, json).then((value) {
      print(value);
      ExhibitionInfo.fromJson(jsonDecode(value));
      Navigator.pushNamed(context, "/modelQR");
    });

    if (kDebugMode) {
      print(ExhibitionInfo());
    }
  }
}

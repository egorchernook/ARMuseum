import 'dart:convert';

import 'package:ar_museum/util/exhibition_info_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../util/app_config.dart';
import '../util/exhibition_info.dart';
import 'base_qr_screen.dart';

class MainQRScanScreen extends BaseQRScreen {
  const MainQRScanScreen({Key? key}) : super(key: key);

  @override
  State<MainQRScanScreen> createState() => _MainQRScanState();
}

class _MainQRScanState extends BaseQRScreenState<MainQRScanScreen> {
  var url = "";

  @override
  Future<void> initState() async {
    super.initState();
    url = await AppConfig.get("mainQRURL");
  }

  @override
  Widget build(BuildContext context) {
    return super.buildQRView(context, _onQRViewCreated);
  }

  Future<dynamic> _sendJSON(String url, Map<String, dynamic> json) async {
    var request = await httpClient!.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(json)));
    var response = await request.close();

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print("Error on json sending");
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
          ExhibitionInfo.fromJson(value);
          Navigator.pushNamed(context, "/modelQR");
        });

        if (kDebugMode) {
          print(ExhibitionInfo());
        }
      }
    });
  }
}

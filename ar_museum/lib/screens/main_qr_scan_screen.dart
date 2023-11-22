import 'dart:convert';

import 'package:ar_museum/util/exhibition_info_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../util/exhibition_info.dart';
import 'base_qr_screen.dart';

class MainQRScanScreen extends BaseQRScreen {
  const MainQRScanScreen({Key? key}) : super(key: key);

  @override
  State<MainQRScanScreen> createState() => _MainQRScanState();
}

class _MainQRScanState extends BaseQRScreenState<MainQRScanScreen> {
  @override
  Widget build(BuildContext context) {
    return super.buildQRView(context, _onQRViewCreated);
  }

  Future<dynamic> _getJson(String url) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    return jsonDecode(await response.transform(utf8.decoder).join());
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

        final json = jsonEncode(event.code!.split("/"));
        if (kDebugMode) {
          print(json);
        }
        // }
        // "museumId"
        // "exhibitionId"
        // }
        var url = ""; // TODO: change

        _getJson(url).then((value) {
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

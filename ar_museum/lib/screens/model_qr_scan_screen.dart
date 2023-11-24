import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// import '../util/app_config.dart';
import '../util/exhibition_info.dart';
import '../util/model_data.dart';
import 'base_qr_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRScanScreen extends BaseQRScreen {
  const QRScanScreen({Key? key}) : super(key: key);

  @override
  State<QRScanScreen> createState() => _QRScanState();
}

class _QRScanState extends BaseQRScreenState<QRScanScreen> {
  @override
  Widget build(BuildContext context) {
    return super.buildQRView(
        context, _onQRViewCreated, AppLocalizations.of(context)!.modelQRText);
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

        final id = int.parse(event.code!);

        Navigator.pushNamed(context, "/arScreen", arguments: id);

        //   _downloadAndUnpack("$url/${event.code!}", "Archive.zip")
        //       .then((value) => Navigator.pushNamed(context, "/modelQR"));
      }
    });
  }

  // Future<ModelData> _downloadModelInfo(int id) async {
  //   final info = ExhibitionInfo.exhibitionData[id];
  //   var directory = Directory(
  //       "${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
  //               : await getApplicationSupportDirectory() //FOR IOS
  //           )!.path}$id");
  //
  //   var request = await httpClient!.getUrl();
  //   var response = await request.close();
  //   var bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  // }
}

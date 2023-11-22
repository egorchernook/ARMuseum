import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'base_qr_screen.dart';

class QRScanScreen extends BaseQRScreen {
  const QRScanScreen({Key? key}) : super(key: key);

  @override
  State<QRScanScreen> createState() => _QRScanState();
}

class _QRScanState extends BaseQRScreenState<QRScanScreen> {
  late UnityWidgetController unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return super.buildQRView(context, _onQRViewCreated);
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

        const url = ""; // TODO: rework

        unityWidgetController.postMessage("XR Origin",
            "downloadFrom", url);

      //   _downloadAndUnpack("$url/${event.code!}", "Archive.zip")
      //       .then((value) => Navigator.pushNamed(context, "/modelQR"));
      }
    });
  }
}

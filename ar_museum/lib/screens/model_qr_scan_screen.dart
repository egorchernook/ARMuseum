import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// import '../util/app_config.dart';
import '../util/exhibition_info.dart';
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

        // unityWidgetController
        //     .postMessage("XR Origin", "downloadFrom",
        //         ExhibitionInfo().exhibitionData[0]?.modelURL)
        //     ?.then((value) =>
      Navigator.pushNamed(context, "/arScreen");

        //   _downloadAndUnpack("$url/${event.code!}", "Archive.zip")
        //       .then((value) => Navigator.pushNamed(context, "/modelQR"));
      }
    });
  }
}

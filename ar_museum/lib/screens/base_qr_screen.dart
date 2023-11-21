import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../util/app_config.dart';

abstract class BaseQRScreen extends StatefulWidget {
  const BaseQRScreen({Key? key}) : super(key: key);
}

abstract class BaseQRScreenState<Screen extends BaseQRScreen>
    extends State<Screen> {
  Barcode? result;
  QRViewController? controller;
  HttpClient? httpClient;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final String serverURL;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Future<void> initState() async {
    super.initState();
    httpClient = HttpClient();
    serverURL = await AppConfig.get("backURL");
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noPermission)),
      );
    }
  }

  Widget buildQRView(
      BuildContext context, Function(QRViewController) onQRViewCreated) {
    final scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 280.0;
    return Scaffold(
        body: Stack(children: [
      QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 5,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              AppLocalizations.of(context)!.mainQRText,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
          ))
    ]));
  }
}

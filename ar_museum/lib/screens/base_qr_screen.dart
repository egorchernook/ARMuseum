import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

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

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    httpClient = HttpClient();
  }

  @override
  void dispose() {
    httpClient?.close();
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

  Widget buildQRView(BuildContext context,
      Function(QRViewController) onQRViewCreated, String text) {
    final scanArea = math.min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) *
        0.675;
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
              text,
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

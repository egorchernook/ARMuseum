import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'base_qr_screen.dart';

class QRScanScreen extends BaseQRScreen {
  const QRScanScreen({Key? key}) : super(key: key);

  @override
  State<QRScanScreen> createState() => _QRScanState();
}

class _QRScanState extends BaseQRScreenState<QRScanScreen> {
  @override
  Widget build(BuildContext context) {
    return super.buildQRView(context, _onQRViewCreated);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      super.controller = controller;
    });

  }
}
// }
// "museumId"
// "exhibitionId"
// }
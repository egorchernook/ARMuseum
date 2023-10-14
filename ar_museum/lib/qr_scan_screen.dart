import 'dart:developer';

import 'package:ar_museum/ar_screen.dart';
import 'package:ar_museum/model_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' show Directory, File, HttpClient, Platform;

/// ТОТАЛЬНЫЙ УРОДСК
/// ПОФИКСИТЬ

class ModelData {
  String? modelDescription;
  String? audioPath;
  List<String>? images;

  ModelData(this.modelDescription, this.audioPath, this.images);
}

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({Key? key}) : super(key: key);

  @override
  State<QRScanScreen> createState() => _QRScanState();
}

class _QRScanState extends State<QRScanScreen> {
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
  Widget build(BuildContext context) {
    httpClient = HttpClient();
    return Scaffold(body: IgnorePointer(child: _buildQrView(context)));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 280.0;
    return Stack(children: [
      QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
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
            child: const Text(
              'Отсканируйте QR код точки',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
          ))
    ]);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    final subscription = controller.scannedDataStream.listen(null);
    subscription.onData((event) {
      if (event.code != null) {
        subscription.cancel();
        controller.stopCamera();
        _downloadAndUnpack(
                "http://176.214.3.242:34/${event.code!}", "Archive.zip")
            .then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ARScreen(modelInfo: ModelInfo(
                          images: value.images!,
                          desription: value.modelDescription!,
                          audioPath: value.audioPath!))),
                ));
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<ModelData> _downloadAndUnpack(String url, String filename) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;

    File file = File("$dir/$filename");
    file.writeAsBytesSync(bytes);
    if (kDebugMode) {
      print("Downloading finished, path: $dir/$filename");
    }

    try {
      await ZipFile.extractToDirectory(
          zipFile: File("$dir/$filename"),
          destinationDir: Directory(dir).absolute);
      if (kDebugMode) {
        print("Unzipping successful");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Unzipping failed: $e");
      }
    }

    // Read model description
    String contents = File("$dir/Description.txt").readAsStringSync();
    List<String> imagePaths = [];

    Directory imageDir = Directory("$dir/images");
    await imageDir.list(recursive: false).forEach((element) {
      imagePaths.add(element.path);
    });

    try {
      await ZipFile.extractToDirectory(
          zipFile: File("$dir/gltfModel_ver3.zip"),
          destinationDir: Directory(dir).absolute);
      if (kDebugMode) {
        print("Unzipping successful");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Unzipping failed: $e");
      }
    }

    return ModelData(contents, "", imagePaths);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

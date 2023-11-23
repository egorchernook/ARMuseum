// import 'dart:developer';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_archive/flutter_archive.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'dart:io' show Directory, File, HttpClient, Platform;
//
// import '../util/app_config.dart';
// import '../util/model_data.dart';
//
// class MainQRScanScreen extends StatefulWidget {
//   const MainQRScanScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainQRScanScreen> createState() => _MainQRScanState();
// }
//
// class _MainQRScanState extends State<MainQRScanScreen> {
//   Barcode? result;
//   QRViewController? controller;
//   HttpClient? httpClient;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   late final String url;
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }
//
//   @override
//   Future<void> initState() async {
//     super.initState();
//     url = await AppConfig.get("backURL");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     httpClient = HttpClient();
//     return Scaffold(body: IgnorePointer(child: _buildQrView(context)));
//   }
//
//   Widget _buildQrView(BuildContext context) {
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 280.0;
//     return Scaffold(
//         body: Stack(children: [
//       QRView(
//         key: qrKey,
//         onQRViewCreated: _onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//             borderColor: Colors.red,
//             borderRadius: 10,
//             borderLength: 30,
//             borderWidth: 5,
//             cutOutSize: scanArea),
//         onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//       ),
//       Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             child: Text(
//               AppLocalizations.of(context)!.mainQRText,
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontSize: 30),
//             ),
//           ))
//     ]));
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     final subscription = controller.scannedDataStream.listen(null);
//     subscription.onData((event) {
//       if (event.code != null) {
//         subscription.cancel();
//         controller.stopCamera();
//         _downloadAndUnpack("$url/${event.code!}", "Archive.zip")
//             .then((value) => Navigator.pushNamed(context, "/modelQR"));
//       }
//     });
//   }
//
//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('no Permission')),
//       );
//     }
//   }
//
//   Future<ModelData> _downloadAndUnpack(String url, String filename) async {
//     var request = await httpClient!.getUrl(Uri.parse(url));
//     var response = await request.close();
//     var bytes = await consolidateHttpClientResponseBytes(response);
//     String dir = (await getApplicationDocumentsDirectory()).path;
//
//     File file = File("$dir/$filename");
//     file.writeAsBytesSync(bytes);
//     if (kDebugMode) {
//       print("Downloading finished, path: $dir/$filename");
//     }
//
//     try {
//       await ZipFile.extractToDirectory(
//           zipFile: File("$dir/$filename"),
//           destinationDir: Directory(dir).absolute);
//       if (kDebugMode) {
//         print("Unzipping successful");
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Unzipping failed: $e");
//       }
//     }
//
//     // Read model description
//     String contents = File("$dir/Description.txt").readAsStringSync();
//     List<String> imagePaths = [];
//
//     Directory imageDir = Directory("$dir/images");
//     await imageDir.list(recursive: false).forEach((element) {
//       imagePaths.add(element.path);
//     });
//
//     try {
//       await ZipFile.extractToDirectory(
//           zipFile: File("$dir/gltfModel_ver3.zip"),
//           destinationDir: Directory(dir).absolute);
//       if (kDebugMode) {
//         print("Unzipping successful");
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Unzipping failed: $e");
//       }
//     }
//
//     return ModelData(contents, "", imagePaths);
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }

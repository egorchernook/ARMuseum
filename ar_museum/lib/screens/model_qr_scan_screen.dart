import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ar_museum/util/model_info.dart';
import 'package:flutter/foundation.dart';
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

        _downloadModelInfo(id).then((value) => Navigator.pushNamed(
                context, "/arScreen",
                arguments: <String, dynamic>{
                  "id": id,
                  "modelInfo": ModelInfo(
                      modelName: value.modelName!,
                      images: value.images!,
                      description: value.modelDescription!,
                      audioPath: value.audioPath!)
                }));
      }
    });
  }

  Future<ModelData> _downloadModelInfo(int id) async {
    final info = ExhibitionInfo.exhibitionData[id]!;
    const audioFileFilename = "audio.mp3";

    var directory = Directory(
            "${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
                    : await getApplicationSupportDirectory() //FOR IOS
                )!.path}/$id")
        .path;

    var request1 = await httpClient!.getUrl(Uri.parse(info.exhibitAudioURL));
    var response1 = await request1.close();
    final bytes = await consolidateHttpClientResponseBytes(response1);
    var file1 = File("${directory}_$audioFileFilename");
    file1.writeAsBytesSync(bytes);
    if (kDebugMode) {
      print("Downloading finished, path: ${directory}_$audioFileFilename");
    }

    var request2 =
        await httpClient!.getUrl(Uri.parse(info.exhibitDescriptionURL));
    var response2 = await request2.close();
    final json = jsonDecode(await response2.transform(utf8.decoder).join())
        as Map<String, dynamic>;
    final name = json["name"] as String;
    final description = json["description"] as String;

    var imagesPaths = <String>[];
    var idx = 0;
    for (var imageUrl in info.imagesURL) {
      var request = await httpClient!.getUrl(Uri.parse(imageUrl));
      var response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      var file = File("${directory}_image_$idx");
      file.writeAsBytesSync(bytes);
      if (kDebugMode) {
        print("Downloading finished, path: ${file.path}");
      }
      imagesPaths.add(file.path);
      idx += 1;
    }

    return ModelData(name, description, file1.path, imagesPaths);
  }
}

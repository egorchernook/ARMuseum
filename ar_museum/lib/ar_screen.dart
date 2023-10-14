import 'dart:io';

import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_museum/qr_scan_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';

class ARScreen extends StatefulWidget
{
  String modelPath;
  ARScreen({Key? key, required this.modelPath}) : super(key: key);

  @override
  State<ARScreen> createState() => _ARScreenState(modelPath : this.modelPath);
}

class _ARScreenState extends State<ARScreen> {
  String modelPath;
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  HttpClient? httpClient;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  _ARScreenState({required this.modelPath});

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  String _platformVersion = 'Unknown';
  static const String _title = 'ARMuseum';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ArFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          // actions: [
          //   IconButton(onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (c)=> const QRScanScreen()));
          //   }, icon: const Icon(
          //     Icons.qr_code_rounded,
          //     color: Colors.white,
          //   ))
          // ],
        ),

        // body: PageView(
        //   controller: _pageController,
        //   physics: const NeverScrollableScrollPhysics(),
        //   children: [
        //     ARView(
        //         onARViewCreated: onARViewCreated,
        //         planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
        //       ),
        //     const QRScanScreen(),
        //   ],
        // ),

        body: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: onRemoveEverything,
                      child: const Text("Remove Everything")),
                ]),
          )
        ]),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      // customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: false,
    );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onNodeTap = onNodeTapped;

    httpClient = HttpClient();
    _downloadAndUnpack(
        "http://176.214.3.242:34/$modelPath",
        "Mammoth.zip");
  }

  Future<void> _downloadAndUnpack(String url, String filename) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    if (kDebugMode) {
      print("Downloading finished, path: $dir/$filename");
    }

    // To print all files in the directory: print(Directory(dir).listSync());
    try {
      await ZipFile.extractToDirectory(
          zipFile: File('$dir/$filename'), destinationDir: Directory(dir));
      if (kDebugMode) {
        print("Unzipping successful");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Unzipping failed: $e");
      }
    }
  }

  Future<void> onRemoveEverything() async {
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    arSessionManager!.onError("Tapped $number node(s)");
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    var newAnchor =
    ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
    if (didAddAnchor!) {
      anchors.add(newAnchor);
      // Add note to anchor
      var newNode = ARNode(
          type: NodeType.fileSystemAppFolderGLTF2,
          uri: "gltfModel_ver3/Mamon.gltf",
          // type: NodeType.webGLB,
          // uri: "http://176.214.3.242:34/test_model",
          scale: Vector3(0.2, 0.2, 0.2),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      bool? didAddNodeToAnchor =
      await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
      if (didAddNodeToAnchor!) {
        nodes.add(newNode);
      } else {
        arSessionManager!.onError("Adding Node to Anchor failed");
      }
    } else {
      arSessionManager!.onError("Adding Anchor failed");
    }
    }
}

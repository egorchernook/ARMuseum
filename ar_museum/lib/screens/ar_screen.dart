import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../util/exhibition_info.dart';
import '../util/model_info.dart';

// import 'model_info.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({Key? key}) : super(key: key);

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen>
    with SingleTickerProviderStateMixin {
  late UnityWidgetController unityWidgetController;
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  late final ModelInfo modelInfo;
  late final Map<String, dynamic> arguments;

  late final animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200))
    ..addListener(() {
      setState(() {});
    });

  late final animation = Tween<Matrix4>(
          begin: Matrix4.translationValues(0, 48, 0), end: Matrix4.identity())
      .animate(animationController);

  void onUnityCreated(controller) {
    unityWidgetController = controller;

    final id = arguments["id"] as int;
    unityWidgetController.postMessage("XR Origin", "downloadFrom",
        ExhibitionInfo.exhibitionData[id]?.modelURL);
  }

  @override
  void dispose() {
    unityWidgetController.dispose();
    super.dispose();
  }

  static const String _title = 'ARMuseum';

  @override
  void initState() {
    super.initState();
  }

  bool isLikeClicked = false;

  void onUnityMessage(message) {
    final messageAsMap = jsonDecode(message) as Map<String, dynamic>;
    String name = messageAsMap['name'];
    String timestamp = messageAsMap['timestamp'];
    String data = messageAsMap['data'];
    switch (name) {
      case 'screenshot':
        if (kDebugMode) {
          print("Time: $timestamp, data : $data");
        }
        break;
      default:
        if (kDebugMode) {
          print('Unknown message from unity');
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    modelInfo = arguments["modelInfo"] as ModelInfo;
    return MaterialApp(
        home: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // leading: BackButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        title: const Text(_title),
      ),
      body: Stack(children: [
        UnityWidget(
          onUnityCreated: onUnityCreated,
          onUnityMessage: onUnityMessage,
          // runImmediately: true,
        ),
        // widget.modelInfo
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Row(children: [
                Expanded(
                    child: IconButton(
                  iconSize: 48, // default - 24
                  onPressed: () {
                    unityWidgetController.postMessage("AR Camera",
                        "TakeScreenshot", "Trying to make screenshot");
                  },
                  icon: const Icon(Icons.photo_camera),
                )),
                const Spacer(),
                const Spacer(),
                const Spacer(),
                Expanded(
                    child: IconButton(
                        iconSize: 48, // default - 24
                        onPressed: () {
                          setState(() {
                            isLikeClicked = !isLikeClicked;
                          });
                        },
                        color: Colors.red,
                        icon: Icon(isLikeClicked
                            ? Icons.favorite
                            : Icons.favorite_border))),
              ])),
          modelInfo
        ])
      ]),
    ));
  }
}

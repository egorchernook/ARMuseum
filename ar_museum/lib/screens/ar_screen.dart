import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

// import 'model_info.dart';

class ARScreen extends StatefulWidget {
  // ModelInfo modelInfo;
  // ARScreen({Key? key, required this.modelInfo}) : super(key: key);
  const ARScreen({Key? key}) : super(key: key);

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late UnityWidgetController unityWidgetController;
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  void onUnityCreated(controller) {
    unityWidgetController = controller;
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
                        onPressed: () {
                          setState(() {
                            isLikeClicked = !isLikeClicked;
                          });
                        },
                        icon: Icon(isLikeClicked
                            ? Icons.favorite
                            : Icons.favorite_border))),
              ])),
          Container(
            width: 300,
            height: 50,
            color: Colors.redAccent,
          )
        ])
      ]),
    ));
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityLoadScreen extends StatefulWidget {
  const UnityLoadScreen({Key? key}) : super(key: key);

  @override
  State<UnityLoadScreen> createState() => _UnityLoadScreenState();
}

class _UnityLoadScreenState extends State<UnityLoadScreen> {
  late UnityWidgetController unityWidgetController;

  @override
  void dispose() {
    unityWidgetController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onUnityMessage(message) {
    final messageAsMap = jsonDecode(message) as Map<String, dynamic>;
    String name = messageAsMap['name'];
    String timestamp = messageAsMap['timestamp'];
    String data = messageAsMap['data'];
    switch (name) {
      case 'splash':
        if (kDebugMode) {
          print("Time: $timestamp, data : $data");
        }
        unityWidgetController.pause();
        Navigator.pushNamed(context, "/languageSettings");
        break;
      default:
        if (kDebugMode) {
          print('Unknown message from unity');
        }
    }
  }

  void _onUnityCreated(UnityWidgetController controller) async {
    unityWidgetController = controller;

    await unityWidgetController.isReady();
    _isExiting = false;
  }

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
        onUnityCreated: _onUnityCreated,
        onUnityMessage: _onUnityMessage,
        onUnitySceneLoaded: _onUnitySceneLoaded,
        unloadOnDispose:false);
  }

  var _isExiting = false;

  void _onUnitySceneLoaded(SceneLoaded? scene) async {
    if (kDebugMode) {
      print('Received scene loaded from unity: ${scene?.name}');
      print('Received scene loaded from unity buildIndex: ${scene?.buildIndex}');
    }

    if (Platform.isAndroid && scene?.buildIndex == 0 && !_isExiting) {
      unityWidgetController.pause()?.then((_) {
        unityWidgetController.resume();
      });
    }
  }
}

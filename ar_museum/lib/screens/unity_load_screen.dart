import 'dart:convert';

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

  // bool _readyToGo = false;

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
        Navigator.pushNamed(context, "/languageSettings");
        break;
      default:
        if (kDebugMode) {
          print('Unknown message from unity');
        }
    }
  }

  void _onUnityCreated(UnityWidgetController controller) {
    unityWidgetController = controller;
    // while (!(await unityWidgetController.isLoaded())! &&
    //     !(await unityWidgetController.isReady())!) {
    //   if (kDebugMode) {
    //     print("Waiting...");
    //   }
    // }
    // if (context.mounted) Navigator.pushNamed(context, "/languageSettings");
  }

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityCreated: _onUnityCreated,
      onUnityMessage: _onUnityMessage,
    );
  }
}

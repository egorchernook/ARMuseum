import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import 'model_info.dart';

class ARScreen extends StatefulWidget
{
  ModelInfo modelInfo;
  ARScreen({Key? key, required this.modelInfo}) : super(key: key);

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late UnityWidgetController unityWidgetController;
  void onUnityCreated(controller) {
    unityWidgetController = controller;
  }

  @override
  void dispose() {
    super.dispose();

  }

  static const String _title = 'ARMuseum';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              WillPopScope(
               onWillPop: () {
                  // Pop the category page if Android back button is pressed.
                },
                child: Container(
                  color: Colors.yellow,
                  child: UnityWidget(
                    onUnityCreated: onUnityCreated,
                  ),
                ),
              ),
              widget.modelInfo
            ]
          ),
        ),
      ),
    );
  }
}

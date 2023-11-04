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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(_title),
        ),
        body: UnityWidget(
          onUnityCreated: onUnityCreated,
          runImmediately: true,
          // widget.modelInfo
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'model_info.dart';

class ARScreen extends StatefulWidget
{
  ModelInfo modelInfo;
  ARScreen({Key? key, required this.modelInfo}) : super(key: key);

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {


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
        body: Stack(children: [
          // ARView(
          //   onARViewCreated: onARViewCreated,
          //   planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          // ),
          widget.modelInfo
        ]),
      ),
    );
  }
}

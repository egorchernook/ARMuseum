import 'package:ar_museum/qr_scan_screen.dart';
import 'package:flutter/material.dart';

import 'ar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String appName = 'ARMuseum';
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$appName app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QRScanScreen(),
    );
  }
}

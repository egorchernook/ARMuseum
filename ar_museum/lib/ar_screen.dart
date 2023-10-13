import 'package:flutter/material.dart';


class ARScreen extends StatefulWidget
{
  const ARScreen({Key? key}) : super(key: key);

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ARMuseum",
        ),
      ),
    );
  }
}

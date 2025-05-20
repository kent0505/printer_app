import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.file});

  static const routePath = '/CameraScreen';

  final File file;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Camera'),
      body: Column(
        children: [
          //
        ],
      ),
    );
  }
}

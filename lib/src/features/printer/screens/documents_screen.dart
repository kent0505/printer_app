import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  static const routePath = '/DocumentsScreen';

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Documents'),
      body: Column(
        children: [],
      ),
    );
  }
}

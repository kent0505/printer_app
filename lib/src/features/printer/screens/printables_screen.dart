import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';

class PrintablesScreen extends StatelessWidget {
  const PrintablesScreen({super.key});

  static const routePath = '/PrintablesScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Printables'),
      body: Column(
        children: [],
      ),
    );
  }
}

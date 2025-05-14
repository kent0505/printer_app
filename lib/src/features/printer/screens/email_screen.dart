import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  static const routePath = '/EmailScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Email'),
      body: Column(
        children: [],
      ),
    );
  }
}

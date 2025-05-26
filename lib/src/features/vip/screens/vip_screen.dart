import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';
import 'vip_sheet.dart';

class VipScreen extends StatelessWidget {
  const VipScreen({super.key, required this.identifier});

  static const routePath = '/VipScreen';

  final String identifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Test vip app bar',
      ),
      body: VipSheet(identifier: identifier),
    );
  }
}

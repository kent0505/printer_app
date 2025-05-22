import 'package:flutter/material.dart';

import 'vip_sheet.dart';

class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  static const routePath = '/VipScreen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: VipSheet(),
    );
  }
}

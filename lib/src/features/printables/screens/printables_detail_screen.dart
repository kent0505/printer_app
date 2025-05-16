import 'package:flutter/material.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/printable.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';

class PrintableDetailScreen extends StatelessWidget {
  const PrintableDetailScreen({super.key, required this.printable});

  static const routePath = '/PrintableDetailScreen';

  final Printable printable;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: printable.title,
        right: Button(
          onPressed: () {},
          child: SvgWidget(
            Assets.share,
            color: colors.accentPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SvgWidget(
                printable.asset,
                height: double.infinity,
              ),
            ),
          ),
          MainButton(
            title: 'Print',
            horizontal: 16,
            onPressed: () {},
          ),
          const SizedBox(height: 44),
        ],
      ),
    );
  }
}

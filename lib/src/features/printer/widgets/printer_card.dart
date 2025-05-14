import 'package:flutter/material.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class PrinterCard extends StatelessWidget {
  const PrinterCard({
    super.key,
    required this.title,
    required this.description,
    required this.asset,
    required this.color,
    this.locked = false,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String asset;
  final Color color;
  final bool locked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    final size = (MediaQuery.sizeOf(context).width / 2) - 24;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Button(
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 64,
                    width: 64,
                    child: asset == Assets.photo
                        ? SvgWidget(asset)
                        : ImageWidget(asset),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 18,
                      fontFamily: AppFonts.inter600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 14,
                      fontFamily: AppFonts.inter400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (locked)
            const Positioned(
              top: 8,
              right: 8,
              child: SvgWidget(Assets.lock),
            ),
        ],
      ),
    );
  }
}

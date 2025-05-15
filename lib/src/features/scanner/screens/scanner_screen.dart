import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/button.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  static const routePath = '/ScannerScreen';

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final controller = MobileScannerController();

  void onStart() {}

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const MobileScanner(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 110,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              color: colors.layerFive,
              child: Row(
                children: [
                  Button(
                    onPressed: () {
                      context.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: colors.bgOne,
                          fontSize: 16,
                          fontFamily: AppFonts.inter600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 66,
            left: 0,
            right: 0,
            child: Button(
              onPressed: onStart,
              child: Container(
                height: 77,
                width: 77,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: colors.tertiaryFour,
                  ),
                ),
                child: Center(
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.tertiaryFour,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

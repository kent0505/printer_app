// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
// import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  static const routePath = '/ScannerScreen';

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String extractedText = '';

  Future<void> pickAndReadText() async {
    // final picker = ImagePicker();
    // final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    // if (pickedImage == null) return;

    // final inputImage = InputImage.fromFile(File(pickedImage.path));
    // final textRecognizer = TextRecognizer();

    // final RecognizedText recognizedText =
    //     await textRecognizer.processImage(inputImage);

    // setState(() {
    //   extractedText = recognizedText.text;
    // });
    // logger(extractedText);
    // textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // MobileScanner(
          //   controller: controller,
          // ),
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
              onPressed: pickAndReadText,
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

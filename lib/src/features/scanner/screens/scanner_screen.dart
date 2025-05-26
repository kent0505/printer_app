import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/loading_widget.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  static const routePath = '/ScannerScreen';

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late CameraController controller;

  String extractedText = '';

  List<CameraDescription> cameras = [];
  List<XFile> photos = [];

  Future<void> takePicture() async {
    final photo = await controller.takePicture();
    photos.add(photo);
    logger(photos.length);
    setState(() {});

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

  void load() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );
    await controller.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      body: cameras.isEmpty
          ? const LoadingWidget()
          : Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 66),
                    height: 77,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Image.file(
                          File(photos.last.path),
                          height: 64,
                          width: 64,
                          fit: BoxFit.cover,
                          frameBuilder: frameBuilder,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(width: 64);
                          },
                        ),
                        const SizedBox(width: 32),
                        const Spacer(),
                        Button(
                          onPressed: takePicture,
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
                        const Spacer(),
                        Button(
                          onPressed: () {},
                          minSize: 28,
                          child: Container(
                            height: 28,
                            width: 96,
                            decoration: BoxDecoration(
                              color: colors.accentPrimary,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Center(
                              child: Text(
                                'Save ${photos.length}',
                                style: TextStyle(
                                  color: colors.bgOne,
                                  fontSize: 14,
                                  fontFamily: AppFonts.inter400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

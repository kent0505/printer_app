import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/rotated_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../firebase/bloc/firebase_bloc.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_screen.dart';
import 'scanned_screen.dart';

class ScannerPreviewScreen extends StatefulWidget {
  const ScannerPreviewScreen({super.key, required this.file});

  static const routePath = '/ScannerPreviewScreen';

  final File file;

  @override
  State<ScannerPreviewScreen> createState() => _ScannerPreviewScreenState();
}

class _ScannerPreviewScreenState extends State<ScannerPreviewScreen> {
  final screenshotController = ScreenshotController();
  late File _file;
  int angle = 0;

  void onDone() async {
    // final bytes = await screenshotController.capture();
    // // final bytes = await getBytes(screenshotController);
    // _file = await getFile(bytes!);
    // final bytes = await screenshotController.capture();
    // final dir = await getTemporaryDirectory();
    // final file =
    //     File('${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
    // await file.writeAsBytes(bytes!);
    // _file = file;
    if (mounted) {
      final vip = context.read<VipBloc>().state;
      if (vip.isVip) {
        if (mounted) {
          context.push(
            ScannedScreen.routePath,
            extra: _file,
          );
        }
      } else {
        context.push(
          VipScreen.routePath,
          extra: context.read<FirebaseBloc>().state.paywall3,
        );
      }
    }
  }

  void onRetake() async {
    await pickImage().then(
      (value) {
        if (value != null) {
          setState(() {
            _file = value;
          });
        }
      },
    );
  }

  Future<void> _cropImage() async {
    final colors = Theme.of(context).extension<MyColors>()!;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          lockAspectRatio: false,
          statusBarColor: colors.textPrimary,
          showCropGrid: false,
          hideBottomControls: true,
          toolbarWidgetColor: colors.accentPrimary,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile != null && mounted) {
      setState(() {
        _file = File(croppedFile.path);
      });
    }
  }

  void _addFilter() async {}

  void _rotateImage() async {
    setState(() {
      if (angle == 0) {
        angle = -90;
      } else if (angle == -90) {
        angle = -180;
      } else if (angle == -180) {
        angle = -270;
      } else {
        angle = 0;
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   final bytes = await screenshotController.capture();
    //   final dir = await getTemporaryDirectory();
    //   final file =
    //       File('${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
    //   await file.writeAsBytes(bytes!);
    //   _file = file;
    //   setState(() {});
    // });
  }

  @override
  void initState() {
    super.initState();
    _file = widget.file;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 16),
                Button(
                  onPressed: onDone,
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: colors.accentPrimary,
                      fontSize: 16,
                      fontFamily: AppFonts.inter600,
                    ),
                  ),
                ),
                const Spacer(),
                Button(
                  onPressed: onRetake,
                  child: Text(
                    'Retake',
                    style: TextStyle(
                      color: colors.accentPrimary,
                      fontSize: 14,
                      fontFamily: AppFonts.inter400,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          Expanded(
            // child: Screenshot(
            //   key: GlobalKey(),
            //   controller: screenshotController,
            child: RotatedWidget(
              degree: angle,
              child: Image.file(
                _file,
                fit: BoxFit.contain,
                frameBuilder: frameBuilder,
              ),
            ),
            // ),
          ),
          // Expanded(
          //   child: Image.file(
          //     _file,
          //     frameBuilder: frameBuilder,
          //   ),
          // ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 16),
                Button(
                  onPressed: _cropImage,
                  child: const SvgWidget(Assets.crop),
                ),
                const Spacer(),
                Button(
                  onPressed: _addFilter,
                  child: const SvgWidget(Assets.colors),
                ),
                const Spacer(),
                SizedBox(
                  height: 44,
                  width: 44,
                  child: Button(
                    onPressed: _rotateImage,
                    child: const SvgWidget(Assets.rotate),
                  ),
                ),
                const Spacer(),
                Button(
                  onPressed: () {
                    context.pop();
                  },
                  child: const SvgWidget(Assets.trash),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }
}

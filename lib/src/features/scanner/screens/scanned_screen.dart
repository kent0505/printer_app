import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../core/utils.dart';
import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/snack_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class ScannedScreen extends StatefulWidget {
  const ScannedScreen({super.key, required this.file});

  static const routePath = '/ScannedScreen';

  final File file;

  @override
  State<ScannedScreen> createState() => _ScannedScreenState();
}

class _ScannedScreenState extends State<ScannedScreen> {
  List<File> files = [];

  void onCopyText() async {
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(
      InputImage.fromFile(files.first),
    );
    logger(recognizedText.text);
    textRecognizer.close();
    await Clipboard.setData(ClipboardData(text: recognizedText.text));
    if (mounted) {
      SnackWidget.show(context, 'Copied to clipboard');
    }
  }

  void onAddImage() async {
    await pickImage(camera: false).then(
      (value) {
        if (value != null) {
          setState(() {
            files.add(value);
          });
        }
      },
    );
  }

  void onShare() {
    shareFiles(files);
  }

  void onPrint() async {
    final pdf = pw.Document();

    for (final file in files) {
      final bytes = await file.readAsBytes();

      pdf.addPage(
        pw.Page(
          margin: pw.EdgeInsets.zero,
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(bytes),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );
    }

    printPdf(pdf);
  }

  @override
  void initState() {
    super.initState();
    files.add(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Scanned Document',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 24,
            fontFamily: AppFonts.inter600,
          ),
        ),
        actions: [
          Button(
            onPressed: () {
              context.pop();
            },
            child: const SvgWidget(
              Assets.close,
              height: 32,
              width: 32,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              itemBuilder: (context, index) {
                return Image.file(
                  files[index],
                  frameBuilder: frameBuilder,
                );
              },
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 16),
                Button(
                  onPressed: onCopyText,
                  child: const SvgWidget(Assets.copy),
                ),
                const Spacer(),
                Button(
                  onPressed: onAddImage,
                  child: const SvgWidget(Assets.image),
                ),
                const Spacer(),
                Button(
                  onPressed: onShare,
                  child: SvgWidget(
                    Assets.share,
                    color: colors.accentPrimary,
                  ),
                ),
                const Spacer(),
                Button(
                  onPressed: onPrint,
                  child: const SvgWidget(Assets.print),
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

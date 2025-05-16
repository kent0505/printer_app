import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/printable.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';

class PrintableDetailScreen extends StatefulWidget {
  const PrintableDetailScreen({super.key, required this.printable});

  static const routePath = '/PrintableDetailScreen';

  final Printable printable;

  @override
  State<PrintableDetailScreen> createState() => _PrintableDetailScreenState();
}

class _PrintableDetailScreenState extends State<PrintableDetailScreen> {
  final screenshotController = ScreenshotController();

  String path = '';
  final pdf = pw.Document();

  void convert() async {
    try {
      await Future.delayed(
        Duration.zero,
        () async {
          Uint8List? imageBytes = await screenshotController.capture();
          if (imageBytes == null) throw Exception();

          final dir = await getTemporaryDirectory();

          pdf.addPage(
            pw.Page(
              margin: pw.EdgeInsets.zero,
              pageFormat: PdfPageFormat.a4,
              build: (context) {
                return pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(imageBytes),
                    fit: pw.BoxFit.contain,
                  ),
                );
              },
            ),
          );

          final file = File('${dir.path}/${widget.printable.title}.jpg');
          await file.writeAsBytes(imageBytes);
          path = file.path;
        },
      );
    } catch (e) {
      logger(e);
    }
  }

  void onShare() async {
    try {
      if (path.isNotEmpty) {
        await Share.shareXFiles(
          [XFile(path)],
          sharePositionOrigin: Rect.fromLTWH(100, 100, 200, 200),
        );
      } else {
        throw Exception('Empty path');
      }
    } catch (e) {
      logger(e);
    }
  }

  void onPrint() {
    Printing.layoutPdf(
      format: PdfPageFormat.a4,
      name: 'Aaa',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  void initState() {
    super.initState();
    convert();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: widget.printable.title,
        right: Button(
          onPressed: onShare,
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
              child: Screenshot(
                controller: screenshotController,
                child: SvgWidget(
                  widget.printable.asset,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          MainButton(
            title: 'Print',
            horizontal: 16,
            onPressed: onPrint,
          ),
          const SizedBox(height: 44),
        ],
      ),
    );
  }
}

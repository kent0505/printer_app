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

  final pdf = pw.Document();
  File file = File('');

  void convert() async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
        () async {
          Uint8List? imageBytes = await screenshotController.capture();
          if (imageBytes == null) throw Exception('imageBytes is null');

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

          file = File('${dir.path}/${widget.printable.title}.png');
          await file.writeAsBytes(imageBytes);
        },
      );
    } catch (e) {
      logger(e);
    }
  }

  void onShare() async {
    try {
      if (file.path.isNotEmpty) {
        await Share.shareXFiles(
          [XFile(file.path)],
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: FittedBox(
                child: Screenshot(
                  controller: screenshotController,
                  child: SvgWidget(
                    widget.printable.asset,
                    height: 180 * 4,
                    width: 134 * 4,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            MainButton(
              title: 'Print',
              asset: Assets.printer,
              onPressed: onPrint,
            ),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key, required this.file});

  static const routePath = '/DocumentsScreen';

  final File file;

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final pdf = pw.Document();

  void createPdf() async {
    try {
      final imageBytes = await widget.file.readAsBytes();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(imageBytes),
              ),
            );
          },
        ),
      );
    } catch (e) {
      logger(e);
    }
  }

  void printDocument() {
    Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  void initState() {
    super.initState();
    createPdf();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: 'Documents',
        right: Button(
          onPressed: printDocument,
          child: const SvgWidget(Assets.printer),
        ),
      ),
      body: PdfPreview(
        useActions: false,
        pdfPreviewPageDecoration: BoxDecoration(color: colors.bgOne),
        scrollViewDecoration: BoxDecoration(color: colors.bgTwo),
        loadingWidget: const LoadingWidget(),
        build: (format) {
          // if (widget.file.readAsString()) return widget.file.readAsBytes();
          return pdf.save();
        },
      ),
    );
  }
}

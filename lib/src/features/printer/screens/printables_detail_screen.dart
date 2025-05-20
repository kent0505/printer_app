import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/printable.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../data/printer_repository.dart';

class PrintableDetailScreen extends StatefulWidget {
  const PrintableDetailScreen({super.key, required this.printable});

  static const routePath = '/PrintableDetailScreen';

  final Printable printable;

  @override
  State<PrintableDetailScreen> createState() => _PrintableDetailScreenState();
}

class _PrintableDetailScreenState extends State<PrintableDetailScreen> {
  final screenshotController = ScreenshotController();

  Uint8List bytes = Uint8List(0);
  File file = File('');
  pw.Document pdf = pw.Document();

  void onShare() async {
    context.read<PrinterRepository>().share([file]);
  }

  void onPrint() async {
    context.read<PrinterRepository>().print(pdf);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        if (mounted) {
          final repo = context.read<PrinterRepository>();
          bytes = await repo.getBytes(screenshotController);
          file = await repo.getFile(bytes);
          pdf = await repo.getPdf(bytes);
          if (mounted) {
            setState(() {});
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: widget.printable.title,
        right: bytes.isEmpty
            ? const SizedBox(
                height: 44,
                width: 44,
                child: LoadingWidget(),
              )
            : Button(
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
                  child: ImageWidget(
                    widget.printable.asset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            MainButton(
              title: 'Print',
              asset: Assets.print,
              active: bytes.isNotEmpty,
              onPressed: onPrint,
            ),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }
}

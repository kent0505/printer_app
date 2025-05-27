import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';

class WebPagesScreen extends StatefulWidget {
  const WebPagesScreen({super.key});

  static const routePath = '/WebPagesScreen';

  @override
  State<WebPagesScreen> createState() => _WebPagesScreenState();
}

class _WebPagesScreenState extends State<WebPagesScreen> {
  late final WebViewController _controller;
  final screenshotController = ScreenshotController();
  final platform = MethodChannel('com.example.webview/screenshot');

  void onLeft() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
    }
  }

  void onRight() async {
    if (await _controller.canGoForward()) {
      _controller.goForward();
    }
  }

  void onReload() async {
    _controller.reload();
  }

  Future<Uint8List?> captureWebViewScreenshot() async {
    try {
      final result = await platform.invokeMethod('captureScreenshot');
      return result as Uint8List?;
    } on PlatformException catch (e) {
      logger('Failed to capture screenshot: ${e.message}');
      return null;
    }
  }

  void onPrint() async {
    try {
      final bytes = await captureWebViewScreenshot();
      // final bytes = await getBytes(screenshotController);
      if (bytes == null) throw Exception('bytes is null');

      final pdf = pw.Document();
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

      printPdf(pdf);
    } catch (e) {
      logger(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://google.com'),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: 'Web Pages',
        right: Button(
          onPressed: onPrint,
          child: const SvgWidget(Assets.print),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: WebViewWidget(controller: _controller),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  onPressed: onLeft,
                  child: SvgWidget(
                    Assets.left,
                    color: colors.textPrimary,
                  ),
                ),
                Button(
                  onPressed: onRight,
                  child: SvgWidget(
                    Assets.right,
                    color: colors.textPrimary,
                  ),
                ),
                Button(
                  onPressed: onReload,
                  child: Icon(
                    Icons.refresh_rounded,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

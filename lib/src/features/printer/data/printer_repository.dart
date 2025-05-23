import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils.dart';

abstract interface class PrinterRepository {
  const PrinterRepository();

  void share(List<File> files);
  void print(Document pdf);
  Future<Uint8List> getBytes(ScreenshotController controller);
  Future<File> getFile(Uint8List bytes);
  Future<File?> pickFile();
  Future<File?> pickImage();
}

final class PrinterRepositoryImpl implements PrinterRepository {
  PrinterRepositoryImpl();

  @override
  void share(List<File> files) async {
    try {
      await Share.shareXFiles(
        List.generate(
          files.length,
          (index) {
            return XFile(files[index].path);
          },
        ),
        sharePositionOrigin: Rect.fromLTWH(100, 100, 200, 200),
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  void print(Document pdf) {
    try {
      Printing.layoutPdf(
        format: PdfPageFormat.a4,
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<Uint8List> getBytes(ScreenshotController controller) async {
    try {
      final bytes = await controller.capture();
      if (bytes == null) throw Exception('null bytes');
      return bytes;
    } catch (e) {
      logger(e);
      return Uint8List(0);
    }
  }

  @override
  Future<File> getFile(Uint8List bytes) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/printable.png');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      return File('');
    }
  }

  @override
  Future<File?> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'png', 'jpg'],
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      logger(e);
    }
    return null;
  }

  @override
  Future<File?> pickImage() async {
    try {
      final photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (photo != null) {
        return File(photo.path);
      }
    } catch (e) {
      logger(e);
    }
    return null;
  }
}

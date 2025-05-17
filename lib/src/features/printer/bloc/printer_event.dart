part of 'printer_bloc.dart';

@immutable
sealed class PrinterEvent {}

final class GetPrintable extends PrinterEvent {
  GetPrintable({
    required this.screenshotController,
    required this.title,
  });

  final ScreenshotController screenshotController;
  final String title;
}

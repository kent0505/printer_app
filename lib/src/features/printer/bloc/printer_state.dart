part of 'printer_bloc.dart';

@immutable
sealed class PrinterState {}

final class PrinterInitial extends PrinterState {}

final class PrintableLoaded extends PrinterState {
  PrintableLoaded({required this.file});

  final File file;
}

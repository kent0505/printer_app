import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

part 'printer_event.dart';
part 'printer_state.dart';

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  PrinterBloc() : super(PrinterInitial()) {
    on<PrinterEvent>(
      (event, emit) => switch (event) {
        GetPrintable() => _getPrintable(event, emit),
      },
    );
  }

  void _getPrintable(
    GetPrintable event,
    Emitter<PrinterState> emit,
  ) async {
    // final bytes = await _repository.getBytes(event.screenshotController);
    // if (bytes != null) {
    //   final file = await _repository.getFile(bytes, event.title);
    //   emit(PrintableLoaded(file: file));
    // }
  }
}

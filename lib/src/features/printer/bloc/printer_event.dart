part of 'printer_bloc.dart';

@immutable
sealed class PrinterEvent {}

final class LoadPhotos extends PrinterEvent {}

final class LoadAlbums extends PrinterEvent {}

final class LoadPhotosFromAlbum extends PrinterEvent {
  LoadPhotosFromAlbum({required this.album});

  final AssetPathEntity album;
}

final class SelectPhoto extends PrinterEvent {
  SelectPhoto({
    required this.bytes,
    this.remove = false,
  });

  final Uint8List bytes;
  final bool remove;
}

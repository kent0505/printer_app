part of 'printer_bloc.dart';

@immutable
sealed class PrinterState {}

final class PrinterInitial extends PrinterState {}

final class PhotosLoaded extends PrinterState {
  PhotosLoaded({
    required this.thumbnails,
    this.selected = const [],
    required this.albumTitle,
  });

  final List<Uint8List?> thumbnails;
  final List<Uint8List> selected;
  final String albumTitle;
}

final class AlbumsLoaded extends PrinterState {
  AlbumsLoaded({required this.albums});

  final List<Album> albums;
}

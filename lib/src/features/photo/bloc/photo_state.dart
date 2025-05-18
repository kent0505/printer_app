part of 'photo_bloc.dart';

@immutable
sealed class PhotoState {}

final class PhotoInitial extends PhotoState {}

final class PhotosLoaded extends PhotoState {
  PhotosLoaded({
    required this.files,
    this.selected = const [],
    required this.albumTitle,
  });

  final List<File?> files;
  final List<File> selected;
  final String albumTitle;
}

final class AlbumsLoaded extends PhotoState {
  AlbumsLoaded({required this.albums});

  final List<Album> albums;
}

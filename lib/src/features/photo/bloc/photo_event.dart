part of 'photo_bloc.dart';

@immutable
sealed class PhotoEvent {}

final class LoadPhotos extends PhotoEvent {}

final class LoadAlbums extends PhotoEvent {}

final class LoadPhotosFromAlbum extends PhotoEvent {
  LoadPhotosFromAlbum({required this.album});

  final AssetPathEntity album;
}

final class SelectPhoto extends PhotoEvent {
  SelectPhoto({
    required this.file,
    this.remove = false,
  });

  final File file;
  final bool remove;
}

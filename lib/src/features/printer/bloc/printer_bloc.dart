import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/models/album.dart';
import '../../../core/utils.dart';

part 'printer_event.dart';
part 'printer_state.dart';

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  List<Uint8List?> thumbnails = [];
  List<Uint8List> selected = [];
  String albumTitle = '';

  PrinterBloc() : super(PrinterInitial()) {
    on<PrinterEvent>(
      (event, emit) => switch (event) {
        LoadPhotos() => _loadPhotos(event, emit),
        LoadAlbums() => _loadAlbums(event, emit),
        LoadPhotosFromAlbum() => _loadPhotosFromAlbum(event, emit),
        SelectPhoto() => _selectPhoto(event, emit),
      },
    );
  }

  void _loadPhotos(
    LoadPhotos event,
    Emitter<PrinterState> emit,
  ) async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth) {
        final List<AssetPathEntity> albums =
            await PhotoManager.getAssetPathList(
          type: RequestType.image,
          onlyAll: true,
        );
        final List<AssetEntity> photos = await albums[0].getAssetListRange(
          start: 0,
          end: 1000,
        );
        thumbnails = await Future.wait(
          photos.map(
            (e) => e.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
          ),
        );
        albumTitle = albums[0].name;

        emit(PhotosLoaded(
          thumbnails: thumbnails,
          albumTitle: albumTitle,
        ));
      } else {
        PhotoManager.openSetting();
      }
    } catch (e) {
      logger(e);
    }
  }

  void _loadAlbums(
    LoadAlbums event,
    Emitter<PrinterState> emit,
  ) async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth) {
        final assetPath = await PhotoManager.getAssetPathList(
          type: RequestType.image,
        );
        List<Album> albums = [];
        for (AssetPathEntity asset in assetPath) {
          final amount = await asset.assetCountAsync;
          if (amount > 0) {
            albums.add(Album(
              asset: asset,
              amount: amount,
            ));
          }
        }
        emit(AlbumsLoaded(albums: albums));
      } else {
        PhotoManager.openSetting();
      }
    } catch (e) {
      logger(e);
    }
  }

  void _loadPhotosFromAlbum(
    LoadPhotosFromAlbum event,
    Emitter<PrinterState> emit,
  ) async {
    try {
      final List<AssetEntity> photos = await event.album.getAssetListRange(
        start: 0,
        end: await event.album.assetCountAsync,
      );
      final thumbnails = await Future.wait(
        photos.map(
          (e) => e.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
        ),
      );
      emit(PhotosLoaded(
        thumbnails: thumbnails,
        albumTitle: event.album.name,
      ));
    } catch (e) {
      logger(e);
    }
  }

  void _selectPhoto(
    SelectPhoto event,
    Emitter<PrinterState> emit,
  ) async {
    try {
      if (event.remove) {
        for (Uint8List bytes in selected) {
          if (bytes == event.bytes) {
            selected.remove(bytes);
            break;
          }
        }
      } else {
        selected.add(event.bytes);
      }
    } catch (e) {
      logger(e);
    }

    emit(PhotosLoaded(
      thumbnails: thumbnails,
      selected: selected,
      albumTitle: albumTitle,
    ));
  }
}

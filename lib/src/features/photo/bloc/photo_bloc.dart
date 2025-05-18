import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/models/album.dart';
import '../../../core/utils.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  List<File?> files = [];
  List<File> selected = [];
  String albumTitle = '';

  PhotoBloc() : super(PhotoInitial()) {
    on<PhotoEvent>(
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
    Emitter<PhotoState> emit,
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
        files = await Future.wait(photos.map((e) => e.file));
        albumTitle = albums[0].name;
        selected = [];
        emit(PhotosLoaded(
          files: files,
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
    Emitter<PhotoState> emit,
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
    Emitter<PhotoState> emit,
  ) async {
    try {
      final List<AssetEntity> photos = await event.album.getAssetListRange(
        start: 0,
        end: await event.album.assetCountAsync,
      );
      files = await Future.wait(photos.map((e) => e.file));
      selected = [];
      emit(PhotosLoaded(
        files: files,
        albumTitle: event.album.name,
      ));
    } catch (e) {
      logger(e);
    }
  }

  void _selectPhoto(
    SelectPhoto event,
    Emitter<PhotoState> emit,
  ) async {
    try {
      if (event.remove) {
        for (File file in selected) {
          if (file == event.file) {
            selected.remove(file);
            break;
          }
        }
      } else {
        selected.add(event.file);
      }
    } catch (e) {
      logger(e);
    }

    emit(PhotosLoaded(
      files: files,
      selected: selected,
      albumTitle: albumTitle,
    ));
  }
}

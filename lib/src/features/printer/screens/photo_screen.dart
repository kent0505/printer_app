import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/album.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/printer_bloc.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  static const routePath = '/PhotoScreen';

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  void onShare() {}

  void onPrint() {}

  @override
  void initState() {
    super.initState();
    context.read<PrinterBloc>().add(LoadPhotos());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    final state = context.watch<PrinterBloc>().state;

    return Scaffold(
      appBar: Appbar(
        right: state is PhotosLoaded && state.selected.isNotEmpty
            ? Button(
                onPressed: onShare,
                child: SvgWidget(
                  Assets.share,
                  color: colors.accentPrimary,
                ),
              )
            : null,
        child: Button(
          onPressed: () {
            context
                .read<PrinterBloc>()
                .add(state is PhotosLoaded ? LoadAlbums() : LoadPhotos());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state is PhotosLoaded ? state.albumTitle : 'Albums',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 14,
                  fontFamily: AppFonts.inter400,
                ),
              ),
              const SizedBox(width: 4),
              SvgWidget(state is PhotosLoaded ? Assets.down : Assets.up),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: switch (state) {
              AlbumsLoaded() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.albums.length,
                  itemBuilder: (context, index) {
                    return _AlbumTile(album: state.albums[index]);
                  },
                ),
              PhotosLoaded() => GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.thumbnails.length,
                  itemBuilder: (context, index) {
                    return _Photo(
                      bytes: state.thumbnails[index]!,
                      selected:
                          state.selected.contains(state.thumbnails[index]!),
                    );
                  },
                ),
              _ => const LoadingWidget(),
            },
          ),
          Container(
            height: 110,
            color: colors.tertiaryFour,
            child: Column(
              children: [
                const SizedBox(height: 10),
                MainButton(
                  title: 'Print',
                  asset: Assets.printer,
                  horizontal: 16,
                  active: state is PhotosLoaded && state.selected.isNotEmpty,
                  onPressed: onPrint,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({
    required this.bytes,
    required this.selected,
  });

  final Uint8List bytes;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        context.read<PrinterBloc>().add(SelectPhoto(
              bytes: bytes,
              remove: selected,
            ));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              frameBuilder: frameBuilder,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          if (selected)
            const Positioned(
              right: 8,
              bottom: 8,
              child: SvgWidget(Assets.checkbox),
            ),
        ],
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return SizedBox(
      height: 80,
      child: Button(
        onPressed: () {
          context
              .read<PrinterBloc>()
              .add(LoadPhotosFromAlbum(album: album.asset));
        },
        child: Row(
          children: [
            ImageWidget(
              Assets.album,
              height: 64,
              width: 64,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(2.5),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  album.asset.name,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontFamily: AppFonts.inter600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  album.amount.toString(),
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                    fontFamily: AppFonts.inter400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

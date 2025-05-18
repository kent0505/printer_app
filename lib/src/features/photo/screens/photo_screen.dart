import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/album.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/photo_bloc.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  static const routePath = '/PhotoScreen';

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  void onShare() async {
    final state = context.read<PhotoBloc>().state;
    if (state is PhotosLoaded) {
      await Share.shareXFiles(
        List.generate(
          state.selected.length,
          (index) => XFile(state.selected[index].path),
        ),
        sharePositionOrigin: Rect.fromLTWH(100, 100, 200, 200),
      );
    }
  }

  void onPrint() async {
    final state = context.read<PhotoBloc>().state;
    if (state is PhotosLoaded) {
      final pdf = pw.Document();

      for (final file in state.selected) {
        final bytes = await file.readAsBytes();

        pdf.addPage(
          pw.Page(
            margin: pw.EdgeInsets.zero,
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(bytes),
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      }

      Printing.layoutPdf(
        format: PdfPageFormat.a4,
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<PhotoBloc>().add(LoadPhotos());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    final state = context.watch<PhotoBloc>().state;

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
                .read<PhotoBloc>()
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
                  itemCount: state.files.length,
                  itemBuilder: (context, index) {
                    return _Photo(
                      file: state.files[index]!,
                      selected: state.selected.contains(state.files[index]),
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
    required this.file,
    required this.selected,
  });

  final File file;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        context
            .read<PhotoBloc>()
            .add(SelectPhoto(file: file, remove: selected));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.file(
              file,
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
              .read<PhotoBloc>()
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

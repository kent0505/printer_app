import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  static const routePath = '/PhotoScreen';

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  List<AssetEntity> _images = [];

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth) {
        final List<AssetPathEntity> albums =
            await PhotoManager.getAssetPathList(
          type: RequestType.image,
          onlyAll: true,
        );
        final List<AssetEntity> media = await albums[0].getAssetListPaged(
          page: 0,
          size: 10000,
        );

        setState(() {
          _images = media;
        });
      } else {
        PhotoManager.openSetting();
      }
    } catch (e) {
      logger(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        right: Button(
          onPressed: () {},
          child: const SvgWidget(Assets.share),
        ),
        child: Button(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name of album',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 14,
                  fontFamily: AppFonts.inter400,
                ),
              ),
              const SizedBox(width: 4),
              const SvgWidget(Assets.down),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Uint8List?>(
                  future: _images[index].thumbnailDataWithSize(
                    const ThumbnailSize(200, 200),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data != null) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          frameBuilder: frameBuilder,
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                );
              },
            ),
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
                  active: false,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

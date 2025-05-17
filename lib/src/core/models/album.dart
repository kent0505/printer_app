import 'package:photo_manager/photo_manager.dart';

class Album {
  Album({
    required this.asset,
    required this.amount,
  });

  final AssetPathEntity asset;
  final int amount;
}

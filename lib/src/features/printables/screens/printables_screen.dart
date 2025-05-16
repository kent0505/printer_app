import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/printable.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import 'printables_detail_screen.dart';

class PrintablesScreen extends StatelessWidget {
  const PrintablesScreen({super.key});

  static const routePath = '/PrintablesScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Printables'),
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          SizedBox(height: 16),
          _Card(
            title: 'Gift cards',
            assets: [
              Assets.card1,
              Assets.card2,
              Assets.card3,
              Assets.card4,
              Assets.card5,
            ],
          ),
          SizedBox(height: 24),
          _Card(
            title: 'Calendars',
            assets: [
              Assets.calendar1,
              Assets.calendar2,
              Assets.calendar3,
              Assets.calendar4,
              Assets.calendar5,
            ],
          ),
          SizedBox(height: 24),
          _Card(
            title: 'Planners',
            assets: [
              Assets.planner1,
              Assets.planner2,
              Assets.planner3,
              Assets.planner4,
              Assets.planner5,
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.assets,
  });

  final String title;
  final List<String> assets;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 8,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 16,
              fontFamily: AppFonts.inter600,
            ),
          ),
        ),
        SizedBox(
          height: 188,
          child: ListView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 8,
            ),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              assets.length,
              (index) {
                final asset = assets[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Button(
                    onPressed: () {
                      context.push(
                        PrintableDetailScreen.routePath,
                        extra: Printable(
                          title: title,
                          asset: asset,
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SvgWidget(asset),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

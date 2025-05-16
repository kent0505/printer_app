import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import 'printer_wifi_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _Unlock(),
        const SizedBox(height: 16),
        const _Subscription(),
        const SizedBox(height: 12),
        _SettingsTile(
          title: 'Share App',
          onPressed: () {},
        ),
        _SettingsTile(
          title: 'Contact Us',
          onPressed: () {},
        ),
        _SettingsTile(
          title: 'FAQ',
          onPressed: () {},
        ),
        _SettingsTile(
          title: 'How to connect a printer to WIFI?',
          onPressed: () {
            context.push(PrinterWifiScreen.routePath);
          },
        ),
        _SettingsTile(
          title: 'Manage Subscription',
          onPressed: () {},
        ),
        _SettingsTile(
          title: 'Terms of Use',
          onPressed: () {},
        ),
        _SettingsTile(
          title: 'Privacy Policy',
          onPressed: () {},
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _Unlock extends StatelessWidget {
  const _Unlock();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return SizedBox(
      height: 182,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 166,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.gradient1,
                  colors.gradient2,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 100,
                  ),
                  child: Text(
                    'Unlock All Features',
                    style: TextStyle(
                      color: colors.bgOne,
                      fontSize: 18,
                      fontFamily: AppFonts.inter600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 100,
                  ),
                  child: Text(
                    'Print web pages, calendars, photos, and more — effortlessly',
                    style: TextStyle(
                      color: colors.bgOne,
                      fontSize: 14,
                      fontFamily: AppFonts.inter400,
                      height: 1.4,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    height: 56,
                    width: 186,
                    decoration: BoxDecoration(
                      color: colors.bgOne,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Button(
                      onPressed: () {},
                      child: Center(
                        child: Text(
                          'Unlock Now',
                          style: TextStyle(
                            color: colors.accentPrimary,
                            fontSize: 16,
                            fontFamily: AppFonts.inter700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Positioned(
            top: -14,
            right: -7,
            child: ImageWidget(
              Assets.allFeatures,
              height: 118,
            ),
          ),
        ],
      ),
    );
  }
}

class _Subscription extends StatelessWidget {
  const _Subscription();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const SizedBox(width: 32),
          Text(
            'Subscription',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 14,
              fontFamily: AppFonts.inter400,
            ),
          ),
          const Spacer(),
          Text(
            'Free',
            style: TextStyle(
              color: colors.accentPrimary,
              fontSize: 16,
              fontFamily: AppFonts.inter600,
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Button(
        onPressed: onPressed,
        minSize: 48,
        child: Row(
          children: [
            const SizedBox(width: 32),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 14,
                  fontFamily: AppFonts.inter400,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const SvgWidget(Assets.right),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }
}

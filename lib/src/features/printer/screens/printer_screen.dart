import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../internet/bloc/internet_bloc.dart';
import '../../internet/widgets/no_internet.dart';
import '../../printables/screens/printables_screen.dart';
import '../widgets/documents_card.dart';
import '../widgets/printer_card.dart';
import 'email_screen.dart';
import 'photo_screen.dart';
import 'web_pages_screen.dart';

class PrinterScreen extends StatelessWidget {
  const PrinterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return BlocBuilder<InternetBloc, bool>(
      builder: (context, hasInternet) {
        if (!hasInternet) return const NoInternet();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DocumentsCard(),
            const SizedBox(height: 16),
            Row(
              children: [
                PrinterCard(
                  title: 'Photo',
                  description: 'Print photos from gallery',
                  asset: Assets.photo,
                  color: colors.tertiaryTwo,
                  onPressed: () {
                    context.push(PhotoScreen.routePath);
                  },
                ),
                const SizedBox(width: 16),
                PrinterCard(
                  title: 'Email',
                  description: 'Print files from your email',
                  asset: Assets.email,
                  color: colors.layerTwo,
                  onPressed: () {
                    context.push(EmailScreen.routePath);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                PrinterCard(
                  title: 'Web Pages',
                  description: 'Print any website in full size',
                  asset: Assets.webPages,
                  color: colors.layerThree,
                  locked: true,
                  onPressed: () {
                    context.push(WebPagesScreen.routePath);
                  },
                ),
                const SizedBox(width: 16),
                PrinterCard(
                  title: 'Printables',
                  description: 'Print giftcards, planners, calendars',
                  asset: Assets.printables,
                  color: colors.layerFour,
                  locked: true,
                  onPressed: () {
                    context.push(PrintablesScreen.routePath);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

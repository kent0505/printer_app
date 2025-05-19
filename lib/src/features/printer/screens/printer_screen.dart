import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/constants.dart';
import '../../internet/bloc/internet_bloc.dart';
import '../../internet/widgets/no_internet.dart';
import '../data/printer_repository.dart';
import '../widgets/printer_card.dart';
import 'documents_screen.dart';
import 'printables_screen.dart';
import 'web_pages_screen.dart';

class PrinterScreen extends StatelessWidget {
  const PrinterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, bool>(
      builder: (context, hasInternet) {
        if (!hasInternet) return const NoInternet();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                PrinterCard(
                  title: 'Documents',
                  description: 'Print Documents from a File',
                  asset: Assets.printer1,
                  color: const [
                    Color(0xff5C9EFD),
                    Color(0xff1A76FF),
                  ],
                  onPressed: () async {
                    final file =
                        await context.read<PrinterRepository>().pickFile();
                    if (file != null && context.mounted) {
                      context.push(
                        DocumentsScreen.routePath,
                        extra: file,
                      );
                    }
                  },
                ),
                const SizedBox(width: 16),
                PrinterCard(
                  title: 'Camera',
                  description: 'Make a photo and print',
                  asset: Assets.printer2,
                  color: const [
                    Color(0xff536ED9),
                    Color(0xff102880),
                  ],
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                PrinterCard(
                  title: 'Photo',
                  description: 'Print photos from gallery',
                  asset: Assets.printer3,
                  color: const [
                    Color(0xffFDE200),
                    Color(0xffF9B400),
                  ],
                  locked: true,
                  onPressed: () {
                    context.push(WebPagesScreen.routePath);
                  },
                ),
                const SizedBox(width: 16),
                PrinterCard(
                  title: 'Email',
                  description: 'Print files from your email',
                  asset: Assets.printer4,
                  color: const [
                    Color(0xff37D6F3),
                    Color(0xff0FBFEE),
                  ],
                  locked: true,
                  onPressed: () {
                    context.push(PrintablesScreen.routePath);
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
                  asset: Assets.printer5,
                  color: const [
                    Color(0xff28F2CA),
                    Color(0xff14DEB6),
                  ],
                  locked: true,
                  onPressed: () {
                    context.push(WebPagesScreen.routePath);
                  },
                ),
                const SizedBox(width: 16),
                PrinterCard(
                  title: 'Printables',
                  description: 'Print giftcards, planners, calendars',
                  asset: Assets.printer6,
                  color: const [
                    Color(0xff9F51FF),
                    Color(0xff603199),
                  ],
                  locked: true,
                  onPressed: () {
                    context.push(PrintablesScreen.routePath);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                PrinterCard(
                  title: 'Invoice',
                  asset: Assets.printer7,
                  color: const [
                    Color(0xff28F23C),
                    Color(0xff0DBE25),
                  ],
                  locked: true,
                  onPressed: () {
                    context.push(WebPagesScreen.routePath);
                  },
                ),
                const SizedBox(width: 16),
                PrinterCard(
                  title: 'PDF',
                  asset: Assets.printer8,
                  color: const [
                    Color(0xffED2F22),
                    Color(0xffB00B00),
                  ],
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/firebase_data.dart';
import '../../firebase/data/firebase_repository.dart';
import '../../internet/bloc/internet_bloc.dart';
import '../../internet/widgets/no_internet.dart';
import '../../photo/screens/photo_screen.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_screen.dart';
import '../data/printer_repository.dart';
import '../widgets/printer_card.dart';
import 'camera_screen.dart';
import 'documents_screen.dart';
import 'email_screen.dart';
import 'printables_screen.dart';
import 'web_pages_screen.dart';

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({super.key});

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  FirebaseData data = FirebaseData(
    invoice: false,
    paywall1: '',
    paywall2: '',
    paywall3: '',
  );

  bool isVip = false;

  void check() async {
    data = await context.read<FirebaseRepository>().checkInvoice();
    setState(() {});
  }

  void checkVip() {
    context.read<VipBloc>().add(CheckVip(identifier: data.paywall1));
    final vip = context.read<VipBloc>().state;
    setState(() {
      isVip = vip.isVip;
    });
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, bool>(
      listener: (context, hasInternet) {
        if (hasInternet) checkVip();
      },
      builder: (context, hasInternet) {
        if (!hasInternet) return const NoInternet();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                PrinterCard(
                  id: 1,
                  title: 'Documents',
                  description: 'Print Documents from a File',
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
                  id: 2,
                  title: 'Camera',
                  description: 'Make a photo and print',
                  onPressed: () async {
                    final file =
                        await context.read<PrinterRepository>().pickImage();
                    if (file != null && context.mounted) {
                      context.push(
                        CameraScreen.routePath,
                        extra: file,
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                PrinterCard(
                  id: 3,
                  title: 'Photo',
                  description: 'Print photos from gallery',
                  onPressed: () {
                    context.push(PhotoScreen.routePath);
                  },
                ),
                const SizedBox(width: 16),
                PrinterCard(
                  id: 4,
                  title: 'Email',
                  description: 'Print files from your email',
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
                  id: 5,
                  title: 'Web Pages',
                  description: 'Print any website in full size',
                  locked: !isVip,
                  onPressed: () {
                    context.push(
                      isVip ? WebPagesScreen.routePath : VipScreen.routePath,
                    );
                  },
                ),
                const SizedBox(width: 16),
                PrinterCard(
                  id: 6,
                  title: 'Printables',
                  description: 'Print giftcards, planners, calendars',
                  locked: !isVip,
                  onPressed: () {
                    context.push(
                      isVip ? PrintablesScreen.routePath : VipScreen.routePath,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (data.invoice)
              Row(
                children: [
                  PrinterCard(
                    id: 7,
                    title: 'Invoice',
                    onPressed: () {
                      context.push(WebPagesScreen.routePath);
                    },
                  ),
                  const SizedBox(width: 16),
                  PrinterCard(
                    id: 8,
                    title: 'PDF',
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

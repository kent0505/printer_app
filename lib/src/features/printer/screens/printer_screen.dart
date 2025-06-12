import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/constants.dart';
import '../../../core/utils.dart';
import '../../firebase/bloc/firebase_bloc.dart';
import '../../internet/bloc/internet_bloc.dart';
import '../../internet/widgets/no_internet.dart';
import '../../photo/screens/photo_screen.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_screen.dart';
import '../widgets/printer_card.dart';
import 'camera_screen.dart';
import 'documents_screen.dart';
import 'email_screen.dart';
import 'printables_screen.dart';
import 'web_pages_screen.dart';

class PrinterScreen extends StatelessWidget {
  const PrinterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, bool>(
      builder: (context, hasInternet) {
        if (!hasInternet) return const NoInternet();

        final isVip = context.watch<VipBloc>().state.isVip;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              PrinterCard(
                id: 1,
                title: 'Documents',
                description: 'Print Documents from a File',
                onPressed: () async {
                  await pickFile().then(
                    (value) {
                      if (value != null && context.mounted) {
                        context.push(
                          DocumentsScreen.routePath,
                          extra: value,
                        );
                      }
                    },
                  );
                },
              ),
              PrinterCard(
                id: 2,
                title: 'Camera',
                description: 'Make a photo and print',
                onPressed: () async {
                  if (await Permission.camera.status.isGranted) {
                    await pickImage().then(
                      (value) {
                        if (value != null && context.mounted) {
                          context.push(
                            CameraScreen.routePath,
                            extra: value,
                          );
                        }
                      },
                    );
                  } else {
                    final result = await Permission.camera.request();
                    if (result.isPermanentlyDenied) {
                      openAppSettings();
                    }
                  }
                },
              ),
              PrinterCard(
                id: 3,
                title: 'Photo',
                description: 'Print photos from gallery',
                onPressed: () {
                  isVip
                      ? context.push(PhotoScreen.routePath)
                      : context.push(
                          VipScreen.routePath,
                          extra: Identifiers.paywall3,
                        );
                },
              ),
              PrinterCard(
                id: 4,
                title: 'Email',
                description: 'Print files from your email',
                onPressed: () {
                  context.push(EmailScreen.routePath);
                },
              ),
              PrinterCard(
                id: 5,
                title: 'Web Pages',
                description: 'Print any website in full size',
                onPressed: () {
                  context.push(WebPagesScreen.routePath);
                },
              ),
              PrinterCard(
                id: 6,
                title: 'Printables',
                description: 'Print giftcards, planners, calendars',
                onPressed: () {
                  isVip
                      ? context.push(PrintablesScreen.routePath)
                      : context.push(
                          VipScreen.routePath,
                          extra: Identifiers.paywall3,
                        );
                },
              ),
              PrinterCard(
                id: 9,
                title: 'Dropbox',
                description: 'Print files from your Dropbox account',
                onPressed: () async {
                  if (isVip) {
                    try {
                      if (!await launchUrl(
                        Uri.parse(Urls.url3),
                      )) {
                        throw 'Could not launch url';
                      }
                    } catch (e) {
                      logger(e);
                    }
                  } else {
                    context.push(
                      VipScreen.routePath,
                      extra: Identifiers.paywall3,
                    );
                  }
                },
              ),
              PrinterCard(
                id: 10,
                title: 'iCloud Drive',
                description: 'Print Documents from iCloud Drive',
                onPressed: () async {
                  if (isVip) {
                    await pickFile().then(
                      (value) {
                        if (value != null && context.mounted) {
                          context.push(
                            DocumentsScreen.routePath,
                            extra: value,
                          );
                        }
                      },
                    );
                  } else {
                    context.push(
                      VipScreen.routePath,
                      extra: Identifiers.paywall3,
                    );
                  }
                },
              ),
              if (context.read<FirebaseBloc>().state.invoice) ...[
                PrinterCard(
                  id: 7,
                  title: 'Invoice',
                  onPressed: () async {
                    try {
                      if (!await launchUrl(
                        Uri.parse(Urls.url1),
                      )) {
                        throw 'Could not launch url';
                      }
                    } catch (e) {
                      logger(e);
                    }
                  },
                ),
                PrinterCard(
                  id: 8,
                  title: 'PDF',
                  onPressed: () async {
                    try {
                      if (!await launchUrl(
                        Uri.parse(Urls.url2),
                      )) {
                        throw 'Could not launch url';
                      }
                    } catch (e) {
                      logger(e);
                    }
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

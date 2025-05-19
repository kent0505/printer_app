import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/button.dart';
import '../screens/documents_screen.dart';

class DocumentsCard extends StatelessWidget {
  const DocumentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      height: 158,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.layerOne,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Button(
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: [
              'pdf',
              'txt',
              'png',
              'jpg',
            ],
          );
          if (result != null && result.files.single.path != null) {
            if (context.mounted) {
              context.push(
                DocumentsScreen.routePath,
                extra: File(result.files.single.path!),
              );
            }
          }
        },
        child: Column(
          children: [
            // const ImageWidget(
            //   Assets.documents,
            //   height: 64,
            // ),
            const SizedBox(height: 8),
            Text(
              'Documents',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 18,
                fontFamily: AppFonts.inter600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Print Documents from a File',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 14,
                fontFamily: AppFonts.inter400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

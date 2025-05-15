import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../settings/screens/printer_wifi_screen.dart';
import '../bloc/home_bloc.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    final state = context.watch<HomeBloc>().state;

    return AppBar(
      centerTitle: false,
      shape: const Border(
        bottom: BorderSide(color: Colors.transparent),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(top: 8),
      title: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          state is HomePrinter ? 'Printer' : 'Settings',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 24,
            fontFamily: AppFonts.inter600,
          ),
        ),
      ),
      actions: [
        state is HomePrinter
            ? Button(
                onPressed: () {
                  context.push(PrinterWifiScreen.routePath);
                },
                minSize: 52,
                child: const SvgWidget(
                  Assets.info,
                  height: 32,
                  width: 32,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

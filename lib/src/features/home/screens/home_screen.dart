import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/vip.dart';
import '../../../core/utils.dart';
import '../../firebase/bloc/firebase_bloc.dart';
import '../../settings/screens/settings_screen.dart';
import '../../printer/screens/printer_screen.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_sheet.dart';
import '../widgets/home_appbar.dart';
import '../widgets/nav_bar.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routePath = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    bool initial = true;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const HomeAppbar(),
      body: BlocListener<VipBloc, Vip>(
        listener: (context, state) {
          // ПОКАЗ ПЕРВОГО ПЕЙВОЛА
          if (!state.isVip &&
              context.mounted &&
              state.offering != null &&
              initial) {
            initial = false;
            VipSheet.show(
              context,
              identifier: context.read<FirebaseBloc>().state.paywall1,
            );
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 62 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  logger(state.runtimeType);
                },
                buildWhen: (previous, current) {
                  return previous.runtimeType != current.runtimeType;
                },
                builder: (context, state) {
                  int index = state is HomePrinter ? 0 : 1;

                  return IndexedStack(
                    index: index,
                    children: const [
                      PrinterScreen(),
                      SettingsScreen(),
                    ],
                  );
                },
              ),
            ),
            const NavBar(),
          ],
        ),
      ),
    );
  }
}

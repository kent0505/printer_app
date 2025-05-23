import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../bloc/vip_bloc.dart';

class VipSheet extends StatefulWidget {
  const VipSheet({super.key, required this.identifier});

  final String identifier;

  static void show(
    BuildContext context, {
    required String identifier,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return VipSheet(identifier: identifier);
      },
    );
  }

  @override
  State<VipSheet> createState() => _VipSheetState();
}

class _VipSheetState extends State<VipSheet> {
  bool isClosed = false;
  bool visible = false;

  void showInfo(String title) {
    if (!isClosed) {
      isClosed = true;
      context.pop();
    }
    DialogWidget.show(context, title: title);
    context.read<VipBloc>().add(CheckVip(identifier: widget.identifier));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<VipBloc>().state;

    if (state.offering == null) {
      return const SizedBox();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        const LoadingWidget(),
        AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: PaywallView(
            offering: state.offering,
            onDismiss: () {
              context.pop();
            },
            onPurchaseCompleted: (customerInfo, storeTransaction) {
              showInfo('Purchase Completed');
            },
            onPurchaseCancelled: () {
              showInfo('Purchase Cancelled');
            },
            onPurchaseError: (e) {
              showInfo('Purchase Error');
            },
            onRestoreCompleted: (customerInfo) {
              showInfo('Restore Completed');
            },
            onRestoreError: (e) {
              showInfo('Restore Error');
            },
          ),
        ),
      ],
    );
  }
}

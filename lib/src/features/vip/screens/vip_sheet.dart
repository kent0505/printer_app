import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/models/vip.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../bloc/vip_bloc.dart';

class VipSheet extends StatefulWidget {
  const VipSheet({super.key, required this.identifier});

  final String identifier;

  static void show(
    BuildContext context, {
    required String identifier,
  }) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return VipSheet(identifier: identifier);
        },
      );
    } catch (e) {
      logger(e);
    }
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
    context.read<VipBloc>().add(CheckVip(identifier: widget.identifier));
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        visible = true;
      });

      if (mounted) {
        if (context.read<VipBloc>().state.offering == null) {
          context.pop();
          DialogWidget.show(context, title: 'Error');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      child: BlocBuilder<VipBloc, Vip>(
        builder: (context, state) {
          if (state.loading || state.offering == null) {
            return const SizedBox();
          }

          return PaywallView(
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
          );
        },
      ),
    );
  }
}

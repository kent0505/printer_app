import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/widgets/dialog_widget.dart';
import '../bloc/vip_bloc.dart';

class VipSheet extends StatelessWidget {
  const VipSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return VipSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<VipBloc>().state;
    bool isClosed = false;

    void showInfo(String title) {
      if (!isClosed) {
        isClosed = true;
        context.pop();
      }

      DialogWidget.show(context, title: title);

      // context.read<VipBloc>().add(CheckVip(identifier: ''));
    }

    if (state.offering == null) {
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
  }
}

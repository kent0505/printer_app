import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VipSheet(identifier: identifier),
          fullscreenDialog: true,
        ),
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
      Navigator.of(context).pop();
    }
    DialogWidget.show(context, title: title);
    context.read<VipBloc>().add(CheckVip(identifier: widget.identifier));
  }

  Future<void> _setPaidUserTag() async {
    try {
      Map<String, String> tags = {
        'subscription_type': 'paid',
        'user_status': 'premium',
        'upgrade_date': DateTime.now().toIso8601String()
      };

      OneSignal.User.addTags(tags);
      logger('OneSignal: Установлены теги для paid пользователя: $tags');
    } catch (e) {
      logger('OneSignal: Ошибка установки paid тегов: $e');
    }
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
          Navigator.of(context).pop();
          DialogWidget.show(context, title: 'Error');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        child: BlocBuilder<VipBloc, Vip>(
          builder: (context, state) {
            if (state.loading || state.offering == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return PaywallView(
              offering: state.offering,
              onDismiss: () {
                Navigator.of(context).pop();
              },
              onPurchaseCompleted: (customerInfo, storeTransaction) async {
                await _setPaidUserTag();
                showInfo('Purchase Completed');
              },
              onPurchaseCancelled: () {
                showInfo('Purchase Cancelled');
              },
              onPurchaseError: (e) {
                showInfo('Purchase Error');
              },
              onRestoreCompleted: (customerInfo) async {
                if (customerInfo.entitlements.active.isNotEmpty) {
                  await _setPaidUserTag();
                }
                showInfo('Restore Completed');
              },
              onRestoreError: (e) {
                showInfo('Restore Error');
              },
            );
          },
        ),
      ),
    );
  }
}

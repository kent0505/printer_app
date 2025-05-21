import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/constants.dart';
import '../../../core/utils.dart';
import 'firebase_data.dart';

abstract interface class FirebaseRepository {
  const FirebaseRepository();

  Future<void> saveInvoice();
  Future<FirebaseData> getInvoice();
}

final class FirebaseRepositoryImpl implements FirebaseRepository {
  FirebaseRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Future<void> saveInvoice() async {
    await _prefs.setBool(Keys.invoice, true);
  }

  @override
  Future<FirebaseData> getInvoice() async {
    try {
      final firebase = FirebaseFirestore.instance;
      final querySnapshot = await firebase
          .collection('invoice')
          .get()
          .timeout(const Duration(seconds: 2));

      final data = FirebaseData.fromJson(querySnapshot.docs[0].data());

      logger(data.invoice);
      logger(data.paywall1);
      logger(data.paywall2);
      logger(data.paywall3);

      await _prefs.setBool(Keys.invoice, data.invoice);

      return data;
    } catch (e) {
      logger(e);
    }

    return FirebaseData(
      invoice: _prefs.getBool(Keys.invoice) ?? false,
      paywall1: _prefs.getString(Keys.paywall1) ?? '',
      paywall2: _prefs.getString(Keys.paywall2) ?? '',
      paywall3: _prefs.getString(Keys.paywall3) ?? '',
    );
  }
}

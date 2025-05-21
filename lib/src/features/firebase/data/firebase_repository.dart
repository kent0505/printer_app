import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/constants.dart';

abstract interface class FirebaseRepository {
  const FirebaseRepository();

  bool hasInvoice();
  Future<void> saveInvoice();
}

final class FirebaseRepositoryImpl implements FirebaseRepository {
  FirebaseRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  bool hasInvoice() {
    return _prefs.getBool(Keys.invoice) ?? false;
  }

  @override
  Future<void> saveInvoice() async {
    await _prefs.setBool(Keys.invoice, true);
  }
}

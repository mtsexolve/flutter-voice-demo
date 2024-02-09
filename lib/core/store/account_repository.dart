import 'dart:convert';
import 'dart:developer';
import 'package:flutter_voice_example/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account.dart';

class AccountRepository {

  static saveAccount(Account account) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(Keys.sharedPreferencesKey, jsonEncode(account.toJson()),);
    log('AccountRepository: saveAccount: account = ${account.toJson()}');
  }

  static Future<Account?> getAccount() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final savedString = sharedPrefs.getString(Keys.sharedPreferencesKey) ?? "";
    log('AccountRepository: getAccount savedString = $savedString');
    return savedString.isNotEmpty ? Account.fromJson(jsonDecode(savedString)) :  null;
  }

}
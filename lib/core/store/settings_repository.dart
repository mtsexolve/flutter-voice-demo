import 'dart:convert';
import 'dart:developer';
import 'package:flutter_voice_example/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

class SettingsRepository {

  static saveSettings(Settings settings) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(Keys.settingsPreferencesKey, jsonEncode(settings.toJson()),);
    log('SettingsRepository: saveSettings: settings = ${settings.toJson()}');
  }

  static Future<Settings> getSettings() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final savedString = sharedPrefs.getString(Keys.settingsPreferencesKey) ?? "";
    log('SettingsRepository: getSettings savedString = $savedString');
    return savedString.isNotEmpty ? Settings.fromJson(jsonDecode(savedString)) :  const Settings(isRingtoneEnabled: false, isDetectLocationEnabled: true);
  }

}
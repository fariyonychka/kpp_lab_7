import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider with ChangeNotifier {
  Locale _locale = const Locale('ua');
  late SharedPreferences _prefs;

  Locale get locale => _locale;

  LocalizationProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final languageCode = _prefs.getString('language_code') ?? 'uk';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    _locale = Locale(languageCode);
    await _prefs.setString('language_code', languageCode);
    notifyListeners();
  }
}

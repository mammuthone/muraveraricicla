import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lingua scelta dall'utente; `null` significa "segui il dispositivo".
class LocaleService extends ChangeNotifier {
  LocaleService._();
  static final LocaleService instance = LocaleService._();

  static const _key = 'locale';
  static const supportate = ['it', 'en', 'fr', 'de', 'es'];

  static const nomi = {
    'it': 'Italiano',
    'en': 'English',
    'fr': 'Français',
    'de': 'Deutsch',
    'es': 'Español',
  };

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null && supportate.contains(code)) _locale = Locale(code);
  }

  Future<void> set(String? code) async {
    _locale = code == null ? null : Locale(code);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (code == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, code);
    }
  }
}

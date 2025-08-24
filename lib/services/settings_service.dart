// services/settings_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  final ValueNotifier<String> _fontFamilyNotifier = ValueNotifier('Roboto');
  final ValueNotifier<double> _fontSizeNotifier = ValueNotifier(16.0);

  ValueNotifier<String> get fontFamilyNotifier => _fontFamilyNotifier;
  ValueNotifier<double> get fontSizeNotifier => _fontSizeNotifier;

  String get fontFamily => _fontFamilyNotifier.value;
  double get fontSize => _fontSizeNotifier.value;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontFamilyNotifier.value = prefs.getString('selected_font') ?? 'Roboto';
    _fontSizeNotifier.value = prefs.getDouble('font_size') ?? 16.0;
  }

  Future<void> updateFontFamily(String font) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_font', font);
    _fontFamilyNotifier.value = font;
  }

  Future<void> updateFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', size);
    _fontSizeNotifier.value = size;
  }
}

import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isLargeFontEnabled = false;

  bool get isDarkMode => _isDarkMode;
  bool get isLargeFontEnabled => _isLargeFontEnabled;

  // Font scale factor: 1.0 default, 1.1 (+10%) when enabled
  double get textScaleFactor => _isLargeFontEnabled ? 1.10 : 1.0;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleLargeFont() {
    _isLargeFontEnabled = !_isLargeFontEnabled;
    notifyListeners();
  }

  void setDarkMode(bool enabled) {
    _isDarkMode = enabled;
    notifyListeners();
  }

  void setLargeFont(bool enabled) {
    _isLargeFontEnabled = enabled;
    notifyListeners();
  }
}

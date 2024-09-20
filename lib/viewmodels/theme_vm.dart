import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  // Toggle the theme between light and dark
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Get the appropriate theme data based on the current theme state
  ThemeData get themeData {
    return _isDarkTheme ? ThemeData.dark() : ThemeData.light();
  }
}

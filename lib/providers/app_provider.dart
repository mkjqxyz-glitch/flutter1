import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  // 1. أضفنا متغير اللغة هنا
  Locale _locale = const Locale('ar'); 

  ThemeMode get themeMode => _themeMode;
  // 2. هذا هو الـ getter الذي يبحث عنه الخطأ في main.dart
  Locale get locale => _locale; 

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // 3. دالة تغيير اللغة (اختياري لكنها مفيدة)
  void toggleLanguage() {
    _locale = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    notifyListeners();
  }
}
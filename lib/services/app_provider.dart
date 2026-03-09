import 'package:flutter/material.dart';
import 'storage_service.dart';

class AppProvider extends ChangeNotifier {
  // هون بنحدد الثيم واللغة والتحكم بالصوت بشكل افتراضي
  ThemeMode _themeMode = ThemeMode.system; 
  Locale _locale = const Locale('ar'); 
  bool _audioEnabled = true;
  
  // الاندكس 1 يعني التطبيق بفتح دايماً على "الرئيسية" مش الكويز
  int _currentIndex = 1; 

  // الـ Getters عشان نقدر نوصل للبيانات من أي مكان بالتطبيق
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get audioEnabled => _audioEnabled;
  int get currentIndex => _currentIndex;

  bool get isArabic => _locale.languageCode == 'ar';
  bool get isEnglish => _locale.languageCode == 'en';

  AppProvider() {
    _loadFromPrefs(); // أول ما يشتغل التطبيق بنجيب الإعدادات المخزنة
  }

  // فنكشن عشان نجيب البيانات من ذاكرة التلفون (SharedPreferences)
  void _loadFromPrefs() {
    _audioEnabled = StorageService.getBool('audio_on', def: true);
    
    // تحميل الثيم اللي كان المستخدم مختاره قبل ما يسكر التطبيق
    final String savedTheme = StorageService.getString('theme_mode', def: 'system');
    _themeMode = _parseThemeMode(savedTheme);
    
    // تحميل اللغة (عربي أو إنجليزي)
    final lang = StorageService.getString('lang', def: 'ar');
    _locale = Locale(lang);
    
    notifyListeners(); // بنخبر التطبيق إنه يحدث الواجهات بناءً على هالداتا
  }

  // تحويل النص المخزن لنوع ThemeMode فعلي
  ThemeMode _parseThemeMode(String themeStr) {
    switch (themeStr) {
      case 'dark': return ThemeMode.dark;
      case 'light': return ThemeMode.light;
      default: return ThemeMode.system;
    }
  }

  // هون بنغير الصفحة لما المستخدم يكبس على المنيو اللي تحت
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // فنكشن بتبدل بين (تلقائي، ليلي، نهاري)
  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.dark;
      StorageService.saveString('theme_mode', 'dark');
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      StorageService.saveString('theme_mode', 'light');
    } else {
      _themeMode = ThemeMode.system;
      StorageService.saveString('theme_mode', 'system');
    }
    notifyListeners(); 
  }

  // تغيير لغة التطبيق بالكامل
  void setLanguage(String langCode) {
    _locale = Locale(langCode);
    StorageService.saveString('lang', langCode);
    notifyListeners();
  }

  // تبديل سريع بين العربي والإنجليزي
  void toggleLanguage() {
    setLanguage(isArabic ? 'en' : 'ar');
  }

  // تشغيل أو إطفاء الأصوات التشجيعية
  void toggleAudio(bool val) {
    _audioEnabled = val;
    StorageService.saveBool('audio_on', val);
    notifyListeners();
  }

  // أهم فنكشن عشان نعرف إذا التطبيق هسا بوضعية الـ Dark Mode أو لا
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return View.of(context).platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
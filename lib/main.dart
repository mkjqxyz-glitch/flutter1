import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// استدعاء الخدمات والمزودات
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'services/app_provider.dart'; 
import 'providers/quiz_provider.dart';

// تأكد من صحة مسار ملف الشاشة الرئيسية لتفادي خطأ creation_with_non_type
import 'screens/home_screen.dart';

void main() async {
  // ضمان تهيئة إطار العمل قبل تشغيل أي خدمات خارجية
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة خدمة التخزين المحلي
  await StorageService.init();
  
  // إنشاء نسخة من خدمة الصوت
  final audioService = AudioService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider(audioService)),
      ],
      child: const ITCareerApp(),
    ),
  );
}

class ITCareerApp extends StatelessWidget {
  const ITCareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'اكتشف الأردن',
          
          // ربط وضع الثيم باختيارات المستخدم من AppProvider
          themeMode: appProvider.themeMode,
          
          // إعدادات الثيم الفاتح المتوافق مع تصميم التطبيق
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.red,
            brightness: Brightness.light,
            fontFamily: 'Cairo', 
            scaffoldBackgroundColor: const Color(0xFFE3F2FD),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          
          // إعدادات الثيم المظلم
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.red,
            brightness: Brightness.dark,
            fontFamily: 'Cairo',
            scaffoldBackgroundColor: const Color(0xFF0F2027),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),

          // إعدادات اللغة والترجمة
          locale: appProvider.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', ''),
            Locale('en', ''),
          ],
          
          // الشاشة الافتتاحية للتطبيق
          home: const HomeScreen(),
        );
      },
    );
  }
}
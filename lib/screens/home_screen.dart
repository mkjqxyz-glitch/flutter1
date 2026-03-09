import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; 
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; 
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart'; 

// استدعاء الخدمات والشاشات المطلوبة للمشروع
import 'package:it_career_app/services/app_provider.dart'; 
import 'package:it_career_app/widgets/glass_button.dart';
import 'package:it_career_app/screens/quiz_screen.dart'; 
import 'package:it_career_app/screens/job_details_screen.dart'; 
import 'package:it_career_app/screens/rating_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    // الفيديو التعريفي الشامل (مطلب أساسي بالواجب)
    final videoId = YoutubePlayer.convertUrlToId("https://youtu.be/p-HZX0-rFS8?si=ajQZsEGaJKmiGwdZ");
    _ytController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void deactivate() {
    _ytController.pause(); 
    super.deactivate();
  }

  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        bool isDark = appProvider.isDarkMode(context);
        bool isEn = appProvider.locale.languageCode == 'en';
        String tr(String ar, String en) => isEn ? en : ar;
        int currentIndex = appProvider.currentIndex;

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true, 
          appBar: currentIndex == 1 ? PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: LiquidGlassLayer(
              settings: LiquidGlassSettings(
                thickness: 5.0,
                blur: 18.0,
                glassColor: Colors.white.withValues(alpha: 0.0),
                refractiveIndex: 1.1,
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                ),
                leading: IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, 
                    color: isDark ? Colors.orangeAccent : Colors.black87
                  ),
                  onPressed: () => appProvider.toggleTheme(), 
                ),
                title: Text(
                  tr("اكتشف الأردن", "Discover Jordan"),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.language, color: isDark ? Colors.white : Colors.black87),
                    onPressed: () => appProvider.toggleLanguage(), 
                  ),
                ],
              ),
            ),
          ) : null,
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: isDark 
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Color(0xFF121212), Colors.black],
                  )
                : const LinearGradient(colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)]),
            ),
            child: SafeArea(
              top: false, 
              bottom: false,
              child: _buildBody(currentIndex, tr, isDark),
            ),
          ),
          bottomNavigationBar: _buildGlassNavbar(appProvider, isDark, tr),
        );
      }
    );
  }

  Widget _buildBody(int index, String Function(String, String) tr, bool isDark) {
    switch (index) {
      case 0: return const QuizScreen(); 
      case 1: return _buildHomeContent(tr, isDark); 
      case 2: return const RatingScreen(); 
      default: return _buildHomeContent(tr, isDark);
    }
  }

  Widget _buildHomeContent(String Function(String, String) tr, bool isDark) {
    return Column(
      children: [
        const SizedBox(height: kToolbarHeight + 60), 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: YoutubePlayer(controller: _ytController, showVideoProgressIndicator: true),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          tr("أبرز المعالم السياحية والأثرية", "Key Tourism & Historical Sites"), 
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87, 
            fontSize: 22, 
            fontWeight: FontWeight.w900
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: [
              _buildCategoryCard(context, tr("مدينة البتراء الوردية", "Petra - The Rose City"), Icons.castle, isDark, tr),
              _buildCategoryCard(context, tr("وادي رم (وادي القمر)", "Wadi Rum"), Icons.landscape, isDark, tr),
              _buildCategoryCard(context, tr("البحر الميت", "The Dead Sea"), Icons.waves, isDark, tr),
              _buildCategoryCard(context, tr("جرش الأثرية", "Ancient Jerash"), Icons.account_balance, isDark, tr),
              _buildCategoryCard(context, tr("عمان", "Amman"), Icons.location_city_rounded, isDark, tr),
              const SizedBox(height: 120), 
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassNavbar(AppProvider appProvider, bool isDark, String Function(String, String) tr) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: LiquidGlassLayer(
        settings: LiquidGlassSettings(thickness: 15.0, blur: 18.0, glassColor: Colors.white.withValues(alpha: 0.0), refractiveIndex: 1.2),
        child: LiquidGlass(
          shape: const LiquidRoundedSuperellipse(borderRadius: 35),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), border: Border.all(color: isDark ? Colors.white10 : Colors.white30, width: 0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navbarItem(appProvider, 0, Icons.quiz_rounded, tr("الاختبار", "Quiz"), isDark, isCenter: false),
                _navbarItem(appProvider, 1, Icons.home_rounded, tr("الرئيسية", "Home"), isDark, isCenter: true),
                _navbarItem(appProvider, 2, Icons.star_rounded, tr("التقييم", "Rating"), isDark, isCenter: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navbarItem(AppProvider appProvider, int index, IconData icon, String label, bool isDark, {required bool isCenter}) {
    bool isSelected = appProvider.currentIndex == index;
    Color activeColor = isDark ? Colors.cyanAccent : Colors.blueAccent;
    Color inactiveColor = isDark ? Colors.white70 : Colors.black54;
    double iconSize = isCenter ? (isSelected ? 38 : 32) : (isSelected ? 28 : 24);

    return GestureDetector(
      onTap: () => appProvider.setIndex(index), 
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? activeColor : inactiveColor, size: iconSize),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? activeColor : inactiveColor, fontSize: isCenter ? 12 : 10, fontWeight: isSelected || isCenter ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, bool isDark, String Function(String, String) tr) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GlassButton(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(jobTitle: title))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isDark ? Colors.white : Colors.blueAccent, size: 28),
            ),
            const SizedBox(width: 20),
            Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 18, fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: isDark ? Colors.white54 : Colors.black26, size: 14),
          ],
        ),
      ),
    );
  }
}
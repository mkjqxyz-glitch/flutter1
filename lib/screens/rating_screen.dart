import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:it_career_app/services/app_provider.dart';
import 'package:it_career_app/providers/quiz_provider.dart'; 
import 'package:it_career_app/widgets/glass_button.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart'; 

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> with TickerProviderStateMixin {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isFeedbackEntered = false;

  late AnimationController _starController;
  late AnimationController _pulseController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.3,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.96,
      upperBound: 1.04,
    )..repeat(reverse: true);

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    _feedbackController.addListener(() {
      setState(() {
        _isFeedbackEntered = _feedbackController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _starController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _handleRating(int index) {
    setState(() => _rating = index);
    _starController.forward(from: 0.8).then((_) => _starController.reverse());
    
    if (index >= 4) {
      _confettiController.play();
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      // استدعاء دالة التصفيق
      // تأكد أن ملف audio_service.dart يحتوي على:
      // await _player.setAsset('assets/sounds/clap_sound.mp3');
      quizProvider.audioService.playClap(); 
    }
  }

  void _submitRating(String Function(String, String) tr, bool isDark) {
    String message = _rating <= 3
        ? tr("شكرا لملاحظاتك، سنعمل على التحسين!", "Thanks for your feedback!")
        : tr("شهادتك نعتز بها! شكرا لتقييمك الرائع 🌟", "Thanks for your amazing rating! 🌟");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _rating >= 4 ? Colors.amber.shade800 : (isDark ? Colors.grey.shade800 : Colors.blueGrey),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    bool isEn = appProvider.locale.languageCode == 'en';
    bool isDark = appProvider.isDarkMode(context);
    String tr(String ar, String en) => isEn ? en : ar;
    Color textColor = isDark ? Colors.white : Colors.black87;

    bool shouldShowSubmit = (_rating >= 4) || (_rating > 0 && _rating <= 3 && _isFeedbackEntered);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true, 
      appBar: PreferredSize(
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
              icon: Icon(Icons.language, color: isDark ? Colors.white : Colors.black87),
              onPressed: () => appProvider.toggleLanguage(), 
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
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, 
                  color: isDark ? Colors.orangeAccent : Colors.black87
                ),
                onPressed: () => appProvider.toggleTheme(), 
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true, 
      body: Stack(
        children: [
          _buildConfetti(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(), 
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - kToolbarHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(tr, textColor),
                    const SizedBox(height: 30),
                    _buildMainCard(isDark, tr, textColor),
                    const SizedBox(height: 25),
                    _buildFeedbackField(isDark, tr, textColor),
                    const SizedBox(height: 35),
                    _buildAnimatedSubmitButton(shouldShowSubmit, tr, isHighRating: _rating >= 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String Function(String, String) tr, Color textColor) {
    return Column(
      children: [
        Text(
          tr("رأيك يهمنا", "Your Opinion Matters"),
          style: GoogleFonts.cairo(color: textColor, fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Container(
          width: 45,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        colors: const [Colors.blue, Colors.green, Colors.orange, Colors.pink, Colors.yellow, Colors.purple],
        createParticlePath: _drawStar,
        numberOfParticles: 30,
        gravity: 0.15,
      ),
    );
  }

  Widget _buildMainCard(bool isDark, String Function(String, String) tr, Color textColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDynamicIcon(isDark),
          const SizedBox(height: 25),
          Text(
            tr("كيف كانت تجربتك السياحية؟", "How was your tourism experience?"),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => _handleRating(index + 1),
                  child: ScaleTransition(
                    scale: _rating == index + 1 ? _starController : const AlwaysStoppedAnimation(1.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.star_rounded,
                        color: index < _rating ? Colors.amber : Colors.grey.shade300,
                        size: 42,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackField(bool isDark, String Function(String, String) tr, Color textColor) {
    bool showField = (_rating > 0 && _rating <= 3);
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: showField
          ? Column(
              children: [
                Text(
                  tr("نأسف لذلك! شاركنا السبب لنتحسن؟", "We're sorry! Tell us why?"),
                  style: GoogleFonts.cairo(color: Colors.amber.shade900, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _feedbackController,
                  maxLines: 2,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: tr("اكتب ملاحظاتك هنا...", "Write feedback..."),
                    hintStyle: GoogleFonts.cairo(color: textColor.withValues(alpha: 0.5), fontSize: 13),
                    filled: true,
                    fillColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildAnimatedSubmitButton(bool show, String Function(String, String) tr, {required bool isHighRating}) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: show ? 1.0 : 0.0,
      child: IgnorePointer(
        ignoring: !show,
        child: ScaleTransition(
          scale: isHighRating ? _pulseController : const AlwaysStoppedAnimation(1.0),
          child: GlassButton(
            onTap: () => _submitRating(tr, Provider.of<AppProvider>(context, listen: false).isDarkMode(context)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: isHighRating 
                    ? [Colors.amber.shade700, Colors.amber.shade900] 
                    : [Colors.grey.shade700, Colors.grey.shade900],
                ),
              ),
              child: Center(
                child: Text(
                  tr("إرسال التقييم", "Submit Review"),
                  style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicIcon(bool isDark) {
    if (_rating == 0) {
      return Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.grey.shade800 : const Color(0xFF262626),
        ),
        child: const Icon(Icons.star_rounded, color: Colors.white, size: 45),
      );
    }

    IconData icon;
    Color color;
    if (_rating <= 2) {
      icon = Icons.sentiment_very_dissatisfied_rounded;
      color = Colors.redAccent;
    } else if (_rating == 3) {
      icon = Icons.sentiment_neutral_rounded;
      color = Colors.amber;
    } else {
      icon = Icons.sentiment_very_satisfied_rounded;
      color = Colors.greenAccent.shade700;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
      child: Icon(icon, key: ValueKey(_rating), color: color, size: 85),
    );
  }

  Path _drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(-90);
    path.moveTo(size.width / 2, 0);
    for (double step = 0; step < numberOfPoints; step++) {
      path.lineTo(
        size.width / 2 + externalRadius * cos(step * degreesPerStep + fullAngle),
        size.height / 2 + externalRadius * sin(step * degreesPerStep + fullAngle),
      );
      path.lineTo(
        size.width / 2 + internalRadius * cos(step * degreesPerStep + halfDegreesPerStep + fullAngle),
        size.height / 2 + internalRadius * sin(step * degreesPerStep + halfDegreesPerStep + fullAngle),
      );
    }
    path.close();
    return path;
  }
}
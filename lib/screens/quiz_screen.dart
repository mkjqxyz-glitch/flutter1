import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:it_career_app/services/app_provider.dart'; 
import 'package:it_career_app/providers/quiz_provider.dart'; 
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _questionIndex = 0;
  int _totalScore = 0; 
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  List<Map<String, dynamic>> _activeQuestions = [];
  
  AnimationController? _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _timerController!.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isAnswered) {
        _handleAnswer(-1, false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _startQuizSession());
  }

  void _startQuizSession() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    bool isEn = appProvider.locale.languageCode == 'en';
    String tr(String ar, String en) => isEn ? en : ar;

    setState(() {
      _activeQuestions = [
        {
          'q': tr('بماذا يلقب وادي رم نظرا لتضاريسه التي تشبه كوكب المريخ؟', 'What is Wadi Rum\'s nickname due to its Mars-like terrain?'), 
          'answers': [
            {'t': tr('الوادي الاخضر', 'The Green Valley'), 'isCorrect': false}, 
            {'t': tr('وادي القمر', 'Valley of the Moon'), 'isCorrect': true}, 
            {'t': tr('وادي المريخ', 'Mars Valley'), 'isCorrect': false}
          ]
        },
        {
          'q': tr('ما هي المدينة الملقبة بـ "المدينة الوردية"؟', 'Which city is known as the "Rose City"?'), 
          'answers': [
            {'t': tr('عمان', 'Amman'), 'isCorrect': false}, 
            {'t': tr('البتراء', 'Petra'), 'isCorrect': true}, 
            {'t': tr('جرش', 'Jerash'), 'isCorrect': false}
          ]
        },
        {
          'q': tr('ما هي عاصمة المملكة الاردنية الهاشمية؟', 'What is the capital of Jordan?'), 
          'answers': [
            {'t': tr('اربد', 'Irbid'), 'isCorrect': false}, 
            {'t': tr('عمان', 'Amman'), 'isCorrect': true}, 
            {'t': tr('الزرقاء', 'Zarqa'), 'isCorrect': false}
          ]
        },
        {
          'q': tr('ما هو اخفض بقعة على وجه الارض الموجودة في الاردن؟', 'What is the lowest point on Earth located in Jordan?'), 
          'answers': [
            {'t': tr('وادي رم', 'Wadi Rum'), 'isCorrect': false}, 
            {'t': tr('البحر الميت', 'Dead Sea'), 'isCorrect': true}, 
            {'t': tr('البحر الاحمر', 'Red Sea'), 'isCorrect': false}
          ]
        },
        {
          'q': tr('بماذا تسمى مدينة جرش الاثرية؟', 'What is the archaeological city of Jerash called?'), 
          'answers': [
            {'t': tr('بومبي الشرق', 'Pompeii of the East'), 'isCorrect': true}, 
            {'t': tr('المدينة الذهبية', 'The Golden City'), 'isCorrect': false}, 
            {'t': tr('مدينة الشمس', 'City of the Sun'), 'isCorrect': false}
          ]
        },
      ];
      _activeQuestions.shuffle(math.Random());
      _timerController?.reset();
      _timerController?.forward();
    });
  }

  @override
  void dispose() {
    _timerController?.dispose();
    super.dispose();
  }

  void _handleAnswer(int index, bool isCorrect) {
    if (_isAnswered) return;
    _timerController?.stop();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      if (isCorrect) {
        _totalScore += 1;
        quizProvider.audioService.playSuccess();
      } else {
        quizProvider.audioService.playFail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    bool isEn = appProvider.locale.languageCode == 'en';
    bool isDark = appProvider.isDarkMode(context);
    String tr(String ar, String en) => isEn ? en : ar;

    if (_activeQuestions.isEmpty) return const Center(child: CircularProgressIndicator());

    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 110), 
            Text(tr("اكتشف الاردن", "Discover Jordan"), 
                style: GoogleFonts.cairo(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            _questionIndex >= _activeQuestions.length 
                ? _buildResultBody(isEn, isDark, tr) 
                : _buildQuizBody(isEn, isDark, tr),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizBody(bool isEn, bool isDark, String Function(String, String) tr) {
    final currentQ = _activeQuestions[_questionIndex];
    return Column(
      children: [
        if (_timerController != null) AnimatedBuilder(
          animation: _timerController!,
          builder: (context, child) {
            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 85, height: 85,
                    child: CircularProgressIndicator(
                      value: 1 - _timerController!.value,
                      strokeWidth: 6,
                      color: Colors.red,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  Text(
                    "${(10 * (1 - _timerController!.value)).ceil()}",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 45),
          child: Divider(color: Colors.red, thickness: 2.5),
        ),
        Text("${tr('السؤال', 'Question')} ${_questionIndex + 1}/${_activeQuestions.length}", 
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(currentQ['q'], textAlign: TextAlign.center, 
              style: GoogleFonts.cairo(fontSize: 19, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        ),
        const SizedBox(height: 35),
        ...List.generate(currentQ['answers'].length, (index) {
          final answer = currentQ['answers'][index];
          Color bgColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white;
          Color textColor = isDark ? Colors.white : Colors.black87;

          if (_isAnswered) {
            if (answer['isCorrect']) {
              bgColor = Colors.green;
              textColor = Colors.white;
            } else if (_selectedAnswerIndex == index) {
              bgColor = Colors.red;
              textColor = Colors.white;
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
            child: GestureDetector(
              onTap: () => _handleAnswer(index, answer['isCorrect']),
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: isDark ? Colors.white30 : Colors.black54, width: 1.2),
                ),
                alignment: Alignment.center,
                child: Text(answer['t'], 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
              ),
            ),
          );
        }),
        const SizedBox(height: 45),
        if (_isAnswered) Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _questionIndex++;
                _isAnswered = false;
                _selectedAnswerIndex = null;
                
                if (_questionIndex < _activeQuestions.length) {
                  _timerController?.reset();
                  _timerController?.forward();
                } else {
                  _timerController?.stop();
                }
              });
            },
            child: Container(
              width: 135, height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF801E35),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 3)
              ),
              alignment: Alignment.center,
              child: Text(tr("التالي", "Next"), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultBody(bool isEn, bool isDark, String Function(String, String) tr) {
    double percentage = _totalScore / _activeQuestions.length;
    String resultTitle;
    String resultMessage;

    if (percentage == 1.0) {
      resultTitle = tr("خبير في تاريخ الاردن", "Jordan History Expert");
      resultMessage = tr("انت ملم في تاريخنا!", "You know our history!");
    } else if (percentage >= 0.6) {
      resultTitle = tr("بطل التحدي", "Challenge Champion");
      resultMessage = tr("اداء رائع ومبهر!", "Great and impressive performance!");
    } else if (percentage >= 0.4) {
      resultTitle = tr("مستكشف تاريخ الاردن", "Jordan History Explorer");
      resultMessage = tr("معلوماتك جيدة، استمر!", "Good knowledge, keep going!");
    } else {
      resultTitle = tr("محاولة جيدة", "Good Try");
      resultMessage = tr("حاول مرة اخرى لتعرف اكثر!", "Try again to learn more!");
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: isDark ? Colors.white30 : Colors.black, width: 1.5)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(resultTitle, 
                    style: TextStyle(color: isDark ? Colors.cyanAccent : Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 18),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: 90, height: 90, 
                        child: CircularProgressIndicator(value: percentage, color: Colors.green, strokeWidth: 9)),
                    Text("${(percentage * 100).toInt()}%", 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: isDark ? Colors.white : Colors.black)),
                  ],
                ),
                const SizedBox(height: 25),
                Text(resultMessage, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: isDark ? Colors.white : Colors.black), textAlign: TextAlign.center),
                const SizedBox(height: 15),
                Text("${tr('الاجابات الصحيحة', 'Correct Answers')} $_totalScore/${_activeQuestions.length}", 
                    style: TextStyle(color: isDark ? Colors.cyanAccent : Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 45),
        _buildActionButton(tr("شارك نتيجتك", "Share Result"), Icons.share, isDark,
            gradient: const LinearGradient(colors: [Colors.red, Colors.black]),
            onTap: () => SharePlus.instance.share(ShareParams(text: "حصلت على $_totalScore في اختبار تاريخ الاردن!"))),
        const SizedBox(height: 15),
        _buildActionButton(tr("اعادة التحدي", "Retry"), null, isDark,
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200, 
            onTap: () => setState(() { _questionIndex = 0; _totalScore = 0; _startQuizSession(); })),
        const SizedBox(height: 130), 
      ],
    );
  }

  Widget _buildActionButton(String title, IconData? icon, bool isDark, {Color? color, Gradient? gradient, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity, height: 60,
          decoration: BoxDecoration(
            color: color,
            gradient: gradient,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isDark && gradient == null ? Colors.white30 : Colors.black, width: 1.1)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.white, size: 21),
              if (icon != null) const SizedBox(width: 10),
              Text(title, style: TextStyle(color: (icon != null || isDark) ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
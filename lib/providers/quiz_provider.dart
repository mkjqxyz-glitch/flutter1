import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/audio_service.dart';

class QuizProvider extends ChangeNotifier {
  final AudioService audioService;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _secondsRemaining = 60;
  Timer? _timer;

  QuizProvider(this.audioService);

  int get currentIndex => _currentIndex;
  int get score => _score;
  int get secondsRemaining => _secondsRemaining;
  Question get currentQuestion => _questions[_currentIndex];

  void startQuiz(List<Question> q) {
    _questions = q;
    _currentIndex = 0;
    _score = 0;
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        if (_secondsRemaining <= 5 && _secondsRemaining > 0) {
          // تم استبدال playBeep بـ playFail أو يمكنك تركها فارغة 
          // لأننا لم نقم بتعريف صوت "تنبيه" خاص بالوقت بعد
          audioService.playFail(); 
        }
        notifyListeners();
      } else {
        nextQuestion();
      }
    });
  }

  void answer(int index) {
    if (index == currentQuestion.correctIndex) {
      _score++;
      // تم التعديل من playCheer إلى playSuccess
      audioService.playSuccess();
    } else {
      // إضافة صوت عند الإجابة الخاطئة أيضاً
      audioService.playFail();
    }
    _timer?.cancel();
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 900), nextQuestion);
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _startTimer();
    } else {
      _timer?.cancel();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
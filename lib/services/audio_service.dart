import 'package:flutter/foundation.dart'; 
import 'package:just_audio/just_audio.dart';

class AudioService {
  // مشغل للأصوات القصيرة (نجاح/فشل/تصفيق)
  final AudioPlayer _player = AudioPlayer();
  
  // مشغل منفصل لصوت التكتكة (عشان ما يقطع إذا اشتغل صوت النجاح/الفشل)
  final AudioPlayer _tickingPlayer = AudioPlayer();

  // 1. دالة تشغيل صوت التكتكة nnnn.mp3
  Future<void> playCustomSound(String fileName) async {
    try {
      // نوقف الصوت إذا كان شغال ونعيده من البداية
      await _tickingPlayer.stop();
      await _tickingPlayer.setAsset('assets/sounds/$fileName');
      await _tickingPlayer.play();
    } catch (e) {
      debugPrint("Error playing ticking sound: $e");
    }
  }

  // 2. دالة إيقاف صوت التكتكة
  Future<void> stopTicking() async {
    try {
      await _tickingPlayer.stop();
    } catch (e) {
      debugPrint("Error stopping ticking sound: $e");
    }
  }

  // 3. دالة تشغيل صوت النجاح
  Future<void> playSuccess() async {
    try {
      if (_player.playing) await _player.stop();
      await _player.setAsset('assets/sounds/success.mp3');
      await _player.play();
    } catch (e) {
      debugPrint("Error playing success sound: $e");
    }
  }

  // 4. دالة تشغيل صوت الخطأ
  Future<void> playFail() async {
    try {
      if (_player.playing) await _player.stop();
      await _player.setAsset('assets/sounds/fail.mp3');
      await _player.play();
    } catch (e) {
      debugPrint("Error playing fail sound: $e");
    }
  }

  // 5. دالة تشغيل صوت التصفيق - تم تعديل المسار للحروف الصغيرة
  Future<void> playClap() async {
    try {
      if (_player.playing) await _player.stop();
      // تم تغيير Clap_Sound.mp3 إلى clap_sound.mp3
      await _player.setAsset('assets/sounds/clap_sound.mp3'); 
      await _player.play();
    } catch (e) {
      debugPrint("Error playing clap sound: $e");
    }
  }

  // تنظيف الذاكرة للمشغلين معا
  void dispose() {
    _player.dispose();
    _tickingPlayer.dispose();
  }
}
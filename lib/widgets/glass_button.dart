import 'dart:ui';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double blur;
  final double borderRadius;

  const GlassButton({
    super.key, 
    required this.child, 
    required this.onTap, 
    this.blur = 15.0, 
    this.borderRadius = 20.0
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius), // أضفنا هذا ليكون تأثير الضغط متناسقاً
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              // تم التحديث هنا: استخدام withValues بدلاً من withOpacity
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2), 
                width: 1.5
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
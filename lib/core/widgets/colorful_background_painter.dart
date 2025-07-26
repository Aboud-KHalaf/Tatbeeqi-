import 'package:flutter/material.dart';

class ColorfulBackgroundPainter extends CustomPainter {
  final bool isDark;

  ColorfulBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = isDark
        ? Colors.pinkAccent.withValues(alpha: 0.2)
        : Colors.pink.withValues(alpha: 0.2);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 80, paint);

    paint.color = isDark
        ? Colors.cyanAccent.withValues(alpha: 0.2)
        : Colors.blueAccent.withValues(alpha: 0.2);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.2), 100, paint);

    paint.color = isDark
        ? Colors.amberAccent.withValues(alpha: 0.2)
        : Colors.orangeAccent.withValues(alpha: 0.2);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 90, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

/// A simple, premium mark: a woven thread arc resolving into a single
/// solid dot — "craft becoming a digital mark". No robots, no circuits.
class CribeItLogo extends StatelessWidget {
  final double size;
  final Color color;

  const CribeItLogo({super.key, this.size = 64, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter(color: color)),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final outerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final innerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.055
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.34;

    final outerRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(outerRect, 0.5, 4.2, false, outerPaint);

    final innerRect = Rect.fromCircle(center: center, radius: radius * 0.6);
    canvas.drawArc(innerRect, 2.4, 3.6, false, innerPaint);

    final dotPaint = Paint()..color = color;
    canvas.drawCircle(center, size.width * 0.075, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => oldDelegate.color != color;
}

import 'package:flutter/material.dart';

class FullCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    final gradient = RadialGradient(
      colors: [
        Colors.red, // Center color
        Colors.red.withOpacity(0.3), // Outer edge color (lighter red)
      ],
      stops: [0.0, 1.0], // Stops at the start and end of the gradient
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
      ); // Add an oval path to create a full circle

    // Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

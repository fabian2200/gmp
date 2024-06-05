import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class Circulo extends CustomPainter {
  Color _color;
  double _angulo;

  Circulo(Color _color, double _angulo) {
    this._color = _color;
    this._angulo = _angulo;
  }
  @override
  void paint(Canvas canvas, Size size) {
    //
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.grey[300]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(center, size.width / 3, paint);

    Paint progressPaint = Paint()
      ..color = _color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 3),
        math.radians(-90), math.radians(_angulo), false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  Offset touchPoint;
  double baseline;
  double touchRadius;
  double pointRadius;
  Color pointColor;
  List<Offset> points;
  CirclePainter({
    this.touchPoint,
    this.touchRadius,
    this.baseline,
    this.points,
    this.pointRadius,
    this.pointColor = Colors.red,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.indigo;
    final redPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = pointColor ?? Colors.red;
    final touchPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.withOpacity(0.3);

    // center line
    canvas.drawLine(
        Offset(baseline, 0), Offset(baseline, size.height), linePaint);

    // draw touchpoint
    if (touchPoint != null) {
      canvas.drawCircle(touchPoint, touchRadius, touchPaint);
    }

    // draw balls
    int ballCount = points?.length ?? 0;
    for (var i = 1; i < ballCount; i++) {
      canvas.drawCircle(points[i], pointRadius, redPaint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return true;
  }
}

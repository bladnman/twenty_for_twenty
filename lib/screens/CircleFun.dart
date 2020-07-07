import 'package:flutter/material.dart';
import 'dart:math';

class CircleFun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circle Fun'),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) => Container(
          width: constraints.widthConstraints().maxWidth,
          height: constraints.heightConstraints().maxHeight,
          color: Colors.yellow,
          child: CustomPaint(
            painter: CircleFunPainter(Offset(300, 200)),
          ),
        ),
      ),
    );
  }
}

const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 5;
const double BALL_DISTANCE = 50;
const double EFFECT_DISTANCE = 300;

class CircleFunPainter extends CustomPainter {
  Offset touchPoint;
  CircleFunPainter(this.touchPoint);

  double affectedAmount(x) {
    double b = (pi * 2) / (EFFECT_DISTANCE * 4);
    double val = cos(b * x);
    var parsed = val.toStringAsFixed(4);
    print('$x => $parsed');
  }

  Offset adjustedOffset(Offset dotOffset) {
    double yToTP = touchPoint.dy - dotOffset.dy;
    double xToTP = touchPoint.dx - dotOffset.dx;

    // print('-----');
    // print('dotOffset : $dotOffset');
    // print('touchPoint : $touchPoint');
    // print('to TouchPoint: $xToTP x $yToTP');
    return dotOffset;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double midX = size.width / 2;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.indigo;
    final redPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;
    final touchPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.withOpacity(0.3);

    // center line
    canvas.drawLine(Offset(midX, 0), Offset(midX, size.height), linePaint);

    // draw touch
    canvas.drawCircle(touchPoint, TOUCH_RADIUS, touchPaint);

    // draw balls
    int ballCount = size.height ~/ BALL_DISTANCE;
    for (var i = 1; i <= ballCount; i++) {
      var offset = adjustedOffset(Offset(midX, (BALL_DISTANCE * i).toDouble()));
      canvas.drawCircle(offset, BALL_RADIUS, redPaint);
    }
  }

  @override
  bool shouldRepaint(CircleFunPainter oldDelegate) {
    return false;
  }
}

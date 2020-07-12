import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';
import 'package:extended_math/extended_math.dart';

const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 5;
const double BALL_DISTANCE = 50;
const double EFFECT_DISTANCE = 150;

class Simple extends StatefulWidget {
  @override
  _SimpleState createState() => _SimpleState();
}

const SCREEN_TITLE = 'SIMPLE';

class _SimpleState extends State<Simple> {
  Offset touchPoint;
  handleTouchPointUpdated(Offset offset) {
    setState(() {
      touchPoint = offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        width: constraints.widthConstraints().maxWidth,
        height: constraints.heightConstraints().maxHeight,
        color: Colors.green.shade100,
        child: TouchPoint(
          onTouchPointUpdated: handleTouchPointUpdated,
          child: CustomPaint(
            painter: SimplePainter(touchPoint: touchPoint),
          ),
        ),
      ),
    );
  }
}

class SimplePainter extends CustomPainter {
  Offset touchPoint;
  SimplePainter({this.touchPoint});

  double affectRelativeToDistancePercFloat(double distance) {
    // no affect outside of range
    if (distance.abs() >= EFFECT_DISTANCE.abs()) {
      return 0.0;
    }
    double b = (pi * 2) / (EFFECT_DISTANCE * 4);
    return cos(b * distance);
  }

  Offset adjustedOffset(Offset dotOffset) {
    if (touchPoint == null) {
      return dotOffset;
    }
    double yToTP = touchPoint.dy - dotOffset.dy;
    double xToTP = touchPoint.dx - dotOffset.dx;
    double amtPercFloat = affectRelativeToDistancePercFloat(yToTP);
    return Offset(dotOffset.dx + (amtPercFloat * xToTP), dotOffset.dy);
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
    if (touchPoint != null) {
      canvas.drawCircle(touchPoint, TOUCH_RADIUS, touchPaint);
    }

    // draw balls
    int ballCount = size.height ~/ BALL_DISTANCE;
    for (var i = 1; i <= ballCount; i++) {
      var offset = adjustedOffset(Offset(midX, (BALL_DISTANCE * i).toDouble()));
      canvas.drawCircle(offset, BALL_RADIUS, redPaint);
    }
  }

  @override
  bool shouldRepaint(SimplePainter oldDelegate) {
    return false;
  }
}

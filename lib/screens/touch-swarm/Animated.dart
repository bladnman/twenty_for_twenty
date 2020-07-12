import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';
import 'package:extended_math/extended_math.dart';

class Animated extends StatefulWidget {
  @override
  _AnimatedState createState() => _AnimatedState();
}

const SCREEN_TITLE = 'ANIMATED';

class _AnimatedState extends State<Animated> with TickerProviderStateMixin {
  Offset touchPoint;
  Animation<double> animation;
  AnimationController controller;
  // Tween<double> _tween = Tween(begin: -math.pi, end: math.pi);
  Tween<double> _tween = Tween(begin: 0, end: 10000);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );
    animation = _tween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // controller.repeat();
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    // controller.forward();
  }

  handleTouchPointUpdated(Offset offset) {
    setState(() {
      touchPoint = offset;
    });

    if (touchPoint == null) {
      controller.stop();
    } else {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SCREEN_TITLE),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) => Container(
          width: constraints.widthConstraints().maxWidth,
          height: constraints.heightConstraints().maxHeight,
          color: Colors.yellow,
          child: TouchPoint(
            onTouchPointUpdated: handleTouchPointUpdated,
            child: CustomPaint(
              painter:
                  MyPainter(touchPoint: touchPoint, aniValue: animation.value),
            ),
          ),
        ),
      ),
    );
  }
}

const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 5;
const double BALL_DISTANCE = 50;
const double EFFECT_DISTANCE = 150;

class MyPainter extends CustomPainter {
  Offset touchPoint;
  double aniValue;
  MyPainter({this.touchPoint, this.aniValue});

  double affectRelativeToDistancePercFloat(double distance) {
    // no affect outside of range
    // if (distance.abs() >= EFFECT_DISTANCE.abs()) {
    //   return 0.0;
    // }
    double b = (pi * 2) / (EFFECT_DISTANCE * 4);
    return cos(b * (distance + aniValue));
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
  bool shouldRepaint(MyPainter oldDelegate) {
    return true;
  }
}

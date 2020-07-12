import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/utils/circle-funcs.dart';
import 'package:twenty_for_twenty/widgets/CirclePainter.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';

const String SCREEN_TITLE = 'DROP';
const Color BG_COLOR = Colors.lightGreen;
const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 4;
const double BALL_DISTANCE = 25;
const double EFFECT_DISTANCE = 150;
const double BASELINE = 100;
const double BASELINE_GRAVITY_PPS = 3000;

class AnimatedDrop extends StatefulWidget {
  @override
  _AnimatedDropState createState() => _AnimatedDropState();
}

class _AnimatedDropState extends State<AnimatedDrop>
    with TickerProviderStateMixin {
  Offset touchPoint;
  Offset lastTouchPoint;
  Animation<double> animation;
  AnimationController aniController;

  startAni({Duration duration, Tween<double> tween}) {
    if (aniController != null) {
      aniController.stop(); // stop any previous ani
    }
    aniController = AnimationController(
      vsync: this,
      duration: duration,
    );
    animation = tween.animate(aniController)
      // every time animation changes, render
      ..addListener(() {
        setState(() {});
      });

    // set it all in motion
    aniController.forward();
  }

  handleTouchPointUpdated(Offset newTouchpoint) {
    Offset prevTouchPoint = touchPoint;

    // keep track of this
    setState(() {
      touchPoint = newTouchpoint;
    });

    // just stopped touching -- set up drop tween
    if (newTouchpoint == null && prevTouchPoint != null) {
      double distance = prevTouchPoint.dx - BASELINE;
      int durationMs = ((distance / BASELINE_GRAVITY_PPS) * 1000).toInt().abs();
      startAni(
        duration: Duration(milliseconds: durationMs),
        tween: Tween<double>(begin: prevTouchPoint.dx, end: BASELINE),
      );
    }

    // touching
    else if (newTouchpoint != null) {
      aniController?.stop();
    }

    if (touchPoint != null) {
      setState(() {
        lastTouchPoint = touchPoint;
      });
    }
  }

  int get ballCount {
    return MediaQuery.of(context).size.height ~/ BALL_DISTANCE;
  }

  List<Offset> get points {
    var aniX = animation?.value ?? touchPoint?.dx;
    // print(aniX);
    Offset adjustedTouchPoint = touchPoint;
    if (adjustedTouchPoint == null) {
      if (aniX != null && lastTouchPoint != null) {
        adjustedTouchPoint = Offset(aniX, lastTouchPoint.dy);
      }
    }

    return List.generate(ballCount, (index) {
      Offset pointOffset = Offset(BASELINE, (BALL_DISTANCE * index).toDouble());
      return adjustedOffset(
        pointOffset: pointOffset,
        effectiveDistance: EFFECT_DISTANCE,
        touchPoint: adjustedTouchPoint,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        width: constraints.widthConstraints().maxWidth,
        height: constraints.heightConstraints().maxHeight,
        color: BG_COLOR,
        child: TouchPoint(
          onTouchPointUpdated: handleTouchPointUpdated,
          child: CustomPaint(
            painter: CirclePainter(
              touchPoint: touchPoint,
              touchRadius: TOUCH_RADIUS,
              points: points,
              pointRadius: BALL_RADIUS,
              baseline: BASELINE,
            ),
          ),
        ),
      ),
    );
  }
}

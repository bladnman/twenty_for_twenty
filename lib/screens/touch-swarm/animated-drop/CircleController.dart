import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/utils/circle-funcs.dart';
import 'package:twenty_for_twenty/widgets/CirclePainter.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';

const String SCREEN_TITLE = 'DROP';
const Color BG_COLOR = Colors.lightGreen;
const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 5;
const double BALL_DISTANCE = 50;
const double EFFECT_DISTANCE = 150;
const double BASELINE = 100;

class CircleController extends StatefulWidget {
  @override
  _CircleControllerState createState() => _CircleControllerState();
}

class _CircleControllerState extends State<CircleController>
    with TickerProviderStateMixin {
  Offset touchPoint;
  Animation<double> animation;
  AnimationController controller;

  Tween<double> _tween = Tween(begin: 0, end: 50);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animation = _tween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // controller.repeat();
          // controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          // controller.forward();
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
      // TODO: set from/to/duration here I bet
      // controller.reset();
      // controller.forward();
    }
  }

  int get ballCount {
    return MediaQuery.of(context).size.height ~/ BALL_DISTANCE;
  }

  List<Offset> get points {
    return List.generate(ballCount, (index) {
      Offset pointOffset = Offset(BASELINE, (BALL_DISTANCE * index).toDouble());
      return adjustedOffset(
        pointOffset: pointOffset,
        effectiveDistance: EFFECT_DISTANCE,
        touchPoint: touchPoint,
      );
    });
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
          color: BG_COLOR,
          child: TouchPoint(
            onTouchPointUpdated: handleTouchPointUpdated,
            child: CustomPaint(
              painter: CirclePainter(
                touchPoint: touchPoint,
                touchRadius: TOUCH_RADIUS,
                points: points,
                pointRadius: BALL_RADIUS,
                baseline: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

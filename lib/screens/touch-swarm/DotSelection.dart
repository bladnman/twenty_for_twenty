import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/utils/circle-funcs.dart';
import 'package:twenty_for_twenty/widgets/CirclePainter.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';

const Color BG_COLOR = Colors.deepPurpleAccent;
const Color BALL_COLOR = Colors.yellow;
const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 8;
const double BALL_DISTANCE = 75;
const double EFFECT_DISTANCE = 75;
const double BASELINE = 100;
const double BASELINE_GRAVITY_PPS = 3000;

class DotSelection extends StatefulWidget {
  @override
  _DotSelectionState createState() => _DotSelectionState();
}

const SCREEN_TITLE = 'DotSelection';

class _DotSelectionState extends State<DotSelection> {
  Offset touchPoint;
  handleTouchPointUpdated(Offset offset) {
    setState(() {
      touchPoint = offset;
    });
  }

  int get ballCount {
    return MediaQuery.of(context).size.height ~/ BALL_DISTANCE;
  }

  List<Offset> get points {
    Offset adjustedTouchPoint = touchPoint;

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
              ballColor: BALL_COLOR,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/widgets/CirclePainter.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';

const Color BG_COLOR = Colors.deepPurpleAccent;
const Color POINT_COLOR = Colors.yellow;
const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 8;
const double BALL_DISTANCE = 75;
const double EFFECT_DISTANCE = 5;
const double BASELINE = 100;
const double BASELINE_GRAVITY_PPS = 3000;

class DotSelection extends StatefulWidget {
  @override
  _DotSelectionState createState() => _DotSelectionState();
}

const SCREEN_TITLE = 'DotSelection';

class _DotSelectionState extends State<DotSelection> {
  Offset touchPoint;
  int _ballCount;
  handleTouchPointUpdated(Offset offset) {
    setState(() {
      touchPoint = offset;
    });
  }

  int get ballCount {
    if (_ballCount == null) {
      _ballCount = MediaQuery.of(context).size.height ~/ BALL_DISTANCE;
    }
    return _ballCount;
  }

  int getClosestDotIndex() {
    // no touch, nothing closest
    if (touchPoint == null) {
      return null;
    }

    double div = touchPoint.dy / BALL_DISTANCE;
    int indexFloor = div.floor();
    double rem = div - indexFloor;

    // closer to next item
    if (rem >= 0.5) {
      // there is a next
      if (ballCount - 1 > indexFloor) {
        return indexFloor + 1;
      }
    }
    return indexFloor.clamp(0, ballCount - 1);
  }

  List<Offset> get points {
    int closestDotIndex = getClosestDotIndex();

    return List.generate(ballCount, (index) {
      Offset pointOffset = Offset(BASELINE, (BALL_DISTANCE * index).toDouble());
      return index != closestDotIndex
          ? pointOffset
          : Offset(touchPoint?.dx ?? BASELINE, pointOffset.dy);
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
              points: points,
              touchRadius: TOUCH_RADIUS,
              pointRadius: BALL_RADIUS,
              pointColor: POINT_COLOR,
              baseline: BASELINE,
            ),
          ),
        ),
      ),
    );
  }
}

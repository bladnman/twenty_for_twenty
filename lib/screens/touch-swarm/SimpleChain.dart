import 'package:extended_math/extended_math.dart';
import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/widgets/CirclePainter.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';

const Color BG_COLOR = Colors.blueGrey;
const Color POINT_COLOR = Colors.yellow;
const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 8;
const double BALL_DISTANCE = 25;
const double EFFECT_DISTANCE = 5;
const double BASELINE = 100;
const double BASELINE_GRAVITY_PPS = 3000;

class SimpleChain extends StatefulWidget {
  @override
  _SimpleChainState createState() => _SimpleChainState();
}

const SCREEN_TITLE = 'SimpleChain';

class _SimpleChainState extends State<SimpleChain> {
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

  int getSelectedDotIndex() {
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
    int selectedDotIndex = getSelectedDotIndex();

    // the points
    List<Offset> thePoints = List.generate(ballCount, (index) {
      Offset pointOffset = Offset(BASELINE, (BALL_DISTANCE * index).toDouble());
      return index != selectedDotIndex
          ? pointOffset
          : Offset(touchPoint?.dx ?? BASELINE, pointOffset.dy);
    });

    // Let's link the dots together
    if (selectedDotIndex != null) {
      linkDots(thePoints, selectedDotIndex);
    }

    return thePoints;
  }

  linkDots(List<Offset> dots, int selectedIndex) {
    // not enough to do anything
    if (dots == null || dots.length < 2 || selectedIndex == null) {
      return;
    }

    // double linkDistance = BALL_DISTANCE;
    double linkDistance = BALL_DISTANCE + 5;
    // link right
    for (var i = selectedIndex; i < dots.length - 1; i++) {
      Offset currentDot = dots[i];
      Offset nextDot = dots[i + 1];
      double x = currentDot.dx - nextDot.dx;
      double y = nextDot.dy - currentDot.dy;
      double z = sqrt(pow(x, 2) + pow(y, 2));
      if (z > linkDistance) {
        num moveXBy = sqrt((pow(linkDistance, 2) - pow(y, 2)).abs());
        dots[i + 1] = Offset(currentDot.dx - moveXBy, nextDot.dy);
      }
    }
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

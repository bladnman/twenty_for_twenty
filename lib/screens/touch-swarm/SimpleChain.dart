import 'package:extended_math/extended_math.dart';
import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/widgets/CirclePainter.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';

const Color BG_COLOR = Colors.blueGrey;
const Color POINT_COLOR = Colors.yellow;
const double TOUCH_RADIUS = 25;
const double BALL_RADIUS = 8;
const double BALL_DISTANCE = 20;
const double EFFECT_DISTANCE = 5;
const double BASELINE = 100;
const double BASELINE_GRAVITY_PPS = 3000;
const double linkDistance = BALL_DISTANCE + 1;

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

  double distance(Offset offset1, Offset offset2) {
    double x = offset1.dx - offset2.dx;
    double y = offset2.dy - offset1.dy;
    return sqrt(pow(x, 2) + pow(y, 2));
  }

  _updateDot({dots, index, linkDistance, selectedIndex, toNextVal}) {
    Offset currentDot = dots[index];
    Offset nextDot = dots[index + toNextVal];
    double dist = distance(currentDot, nextDot);
    double absDistanceApart = dist.abs();

    // too far away - come here
    if (absDistanceApart > linkDistance.abs()) {
      double absToMove = absDistanceApart - linkDistance.abs();
      /**
       * greatly simplifying the "move by" logic. instead of
       * getting precise value with x^2 + y^2 = x^2 we are simply
       * moving the ball on the x-axis the "distance" remainder after
       * subtracting linkDistance. 
       * 
       * This is imprecise and actually helps create a more natural
       * curvature in the falloff.
       * 
       */
      double moveXBy =
          (currentDot.dx - BASELINE < 1) ? absToMove * -1 : absToMove;

      double nextX = nextDot.dx + moveXBy;
      dots[index + toNextVal] = Offset(nextX, nextDot.dy);
    }
  }

  linkDots(List<Offset> dots, int selectedIndex) {
    // not enough to do anything
    if (dots == null || dots.length < 2 || selectedIndex == null) {
      return;
    }

    // link right
    for (var i = selectedIndex; i < dots.length - 1; i++) {
      _updateDot(
        dots: dots,
        index: i,
        selectedIndex: selectedIndex,
        linkDistance: linkDistance,
        toNextVal: 1,
      );
    }
    // link left
    for (var i = selectedIndex; i >= 1; i--) {
      _updateDot(
        dots: dots,
        index: i,
        selectedIndex: selectedIndex,
        linkDistance: linkDistance,
        toNextVal: -1,
      );
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

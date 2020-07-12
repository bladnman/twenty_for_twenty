import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/screens/touch-swarm/animated-first/CircleFunPainter.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';

class CircleFunAnimated extends StatefulWidget {
  @override
  _CircleFunAnimatedState createState() => _CircleFunAnimatedState();
}

const SCREEN_TITLE = 'ANIMATED';

class _CircleFunAnimatedState extends State<CircleFunAnimated>
    with TickerProviderStateMixin {
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
              painter: CircleFunPainter(
                  touchPoint: touchPoint, aniValue: animation.value),
            ),
          ),
        ),
      ),
    );
  }
}

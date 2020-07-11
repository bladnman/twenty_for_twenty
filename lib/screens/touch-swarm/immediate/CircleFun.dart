import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/screens/touch-swarm/immediate/CircleFunPainter.dart';
import 'package:twenty_for_twenty/widgets/TouchPoint.dart';

class CircleFun extends StatefulWidget {
  @override
  _CircleFunState createState() => _CircleFunState();
}

class _CircleFunState extends State<CircleFun> {
  Offset touchPoint;
  handleTouchPointUpdated(Offset offset) {
    setState(() {
      touchPoint = offset;
    });
  }

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
          child: TouchPoint(
            onTouchPointUpdated: handleTouchPointUpdated,
            child: CustomPaint(
              painter: CircleFunPainter(touchPoint: touchPoint),
            ),
          ),
        ),
      ),
    );
  }
}

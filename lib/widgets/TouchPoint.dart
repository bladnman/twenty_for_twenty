import 'package:flutter/material.dart';

typedef TouchPointUpdatedCallback = void Function(Offset touchPointOffset);

class TouchPoint extends StatefulWidget {
  final Widget child;
  final TouchPointUpdatedCallback onTouchPointUpdated;

  TouchPoint({this.child, this.onTouchPointUpdated});

  @override
  _TouchPointState createState() => _TouchPointState();
}

class _TouchPointState extends State<TouchPoint> {
  Offset _offset;

  updateOffset(offset) {
    setState(() {
      _offset = offset;
    });
    if (widget.onTouchPointUpdated != null) {
      widget.onTouchPointUpdated(_offset);
    }
  }

  handlePanStart(DragStartDetails details) {
    updateOffset(details.localPosition);
  }

  handlePanUpdate(DragUpdateDetails details) {
    updateOffset(details.localPosition);
  }

  handlePanEnd(DragEndDetails details) {
    updateOffset(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: handlePanStart,
      onPanUpdate: handlePanUpdate,
      onPanEnd: handlePanEnd,
      child: widget.child,
    );
  }
}

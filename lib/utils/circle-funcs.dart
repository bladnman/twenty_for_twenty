import 'package:extended_math/extended_math.dart';
import 'package:flutter/material.dart';

Offset adjustedOffset({
  Offset pointOffset,
  Offset touchPoint,
  double effectiveDistance,
}) {
  if (touchPoint == null) {
    return pointOffset;
  }
  double yToTP = touchPoint.dy - pointOffset.dy;
  double xToTP = touchPoint.dx - pointOffset.dx;
  double amtPercFloat = affectRelativeToDistancePercFloat(
    distance: yToTP,
    effectiveDistance: effectiveDistance,
  );
  return Offset(pointOffset.dx + (amtPercFloat * xToTP), pointOffset.dy);
}

double affectRelativeToDistancePercFloat(
    {double distance, double effectiveDistance}) {
  // no affect outside of range
  if (distance.abs() >= effectiveDistance.abs()) {
    return 0.0;
  }
  double b = (pi * 2) / (effectiveDistance * 4);
  return cos(b * (distance)); // + aniValue
}

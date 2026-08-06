import 'package:flutter/services.dart';
import 'package:snake_app/core/models/direction.dart';

Direction? directionFromLogicalKey(LogicalKeyboardKey logicalKey) {
  if (logicalKey == LogicalKeyboardKey.arrowUp ||
      logicalKey == LogicalKeyboardKey.keyW) {
    return Direction.up;
  }
  if (logicalKey == LogicalKeyboardKey.arrowDown ||
      logicalKey == LogicalKeyboardKey.keyS) {
    return Direction.down;
  }
  if (logicalKey == LogicalKeyboardKey.arrowLeft ||
      logicalKey == LogicalKeyboardKey.keyA) {
    return Direction.left;
  }
  if (logicalKey == LogicalKeyboardKey.arrowRight ||
      logicalKey == LogicalKeyboardKey.keyD) {
    return Direction.right;
  }
  return null;
}

Direction? directionFromSwipeVelocity({
  required double velocityX,
  required double velocityY,
  double threshold = 120,
}) {
  if (velocityX.abs() < threshold && velocityY.abs() < threshold) {
    return null;
  }
  if (velocityX.abs() > velocityY.abs()) {
    return velocityX > 0 ? Direction.right : Direction.left;
  }
  return velocityY > 0 ? Direction.down : Direction.up;
}

Direction? directionFromPanDelta({
  required Offset delta,
  required double minDistance,
}) {
  if (delta.distance < minDistance) return null;
  if (delta.dx.abs() > delta.dy.abs()) {
    return delta.dx > 0 ? Direction.right : Direction.left;
  }
  return delta.dy > 0 ? Direction.down : Direction.up;
}

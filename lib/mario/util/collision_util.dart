import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/mario/constants/hit_edge.dart';

class CollisionUtil {
  static HitEdge getHitEdge(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // 0 top; 1 right; 2 bottom; 3 left;
    List<double> listX = intersectionPoints.map((e) => e.x).toList();
    double diffX = listX.reduce(max) - listX.reduce(min);
    List<double> listY = intersectionPoints.map((e) => e.y).toList();
    double diffY = listY.reduce(max) - listY.reduce(min);
    if (diffX > diffY) {
      if ((intersectionPoints.elementAt(0).y - other.y).abs() <
          (intersectionPoints.elementAt(0).y - other.y - other.height).abs()) {
        return HitEdge.top;
      } else {
        return HitEdge.bottom;
      }
    } else {
      if ((intersectionPoints.elementAt(0).x - other.x).abs() <
          (intersectionPoints.elementAt(0).x - other.x - other.width).abs()) {
        return HitEdge.left;
      } else {
        return HitEdge.right;
      }
    }
  }
}

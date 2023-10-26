import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';

class HitboxScale extends PositionComponent with CollisionCallbacks {
  HitboxScale({super.size});

  @override
  FutureOr<void> onLoad() {
    add(RectangleComponent());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    debugPrint('intersectionPoints=$intersectionPoints');
    debugPrint('other=$other');
    if (other is ColliderBlock) {}
  }
}

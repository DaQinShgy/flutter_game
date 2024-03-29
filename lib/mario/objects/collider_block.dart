import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ColliderBlock extends PositionComponent {
  ColliderBlock({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}

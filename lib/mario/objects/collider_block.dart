import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ColliderBlock extends PositionComponent {
  /// Invisible sprites placed overtop background parts
  /// that can be collided with (pipes, steps, ground, etc.)
  ColliderBlock({super.position, super.size});

  @override
  bool get debugMode => true;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}

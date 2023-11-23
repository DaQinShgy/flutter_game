import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/mario_game.dart';

class PowerupFlower extends SpriteAnimationComponent
    with HasGameRef<MarioGame>, CollisionCallbacks {
  PowerupFlower({super.position, super.priority = -1});

  List<List<double>> flowerVector = [
    [0, 32, 16, 16],
    [16, 32, 16, 16],
    [32, 32, 16, 16],
    [48, 32, 16, 16],
  ];

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.spriteList(
      flowerVector
          .map((e) => Sprite(
                game.images.fromCache('mario/item_objects.png'),
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: 0.08,
    );

    add(RectangleHitbox(collisionType: CollisionType.passive));

    add(MoveByEffect(
      Vector2(0, -16),
      LinearEffectController(0.6),
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MarioPlayer) {
      removeFromParent();
    }
  }
}

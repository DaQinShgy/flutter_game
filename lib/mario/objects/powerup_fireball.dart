import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/hole.dart';

class PowerupFireball extends SpriteAnimationComponent
    with HasGameRef<MarioGame>, CollisionCallbacks {
  PowerupFireball(
    this.horizontalDirection, {
    super.position,
    super.anchor = Anchor.bottomLeft,
  });

  List<List<double>> flyVector = [
    [96, 144, 8, 8],
    [104, 144, 8, 8],
    [96, 152, 8, 8],
    [104, 152, 8, 8],
  ];

  List<List<double>> explodeVector = [
    [112, 144, 16, 16],
    [112, 160, 16, 16],
    [112, 176, 16, 16],
  ];

  final int horizontalDirection;

  double jumpSpeed = 0;

  bool collideHole = false;

  @override
  FutureOr<void> onLoad() {
    animation = _getAnimation(flyVector);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    x += ObjectValues.fireBallSpeed * horizontalDirection * dt;
    jumpSpeed += ObjectValues.fireBallGravityAccel * dt;
    y += jumpSpeed * dt;
    if (y >= ObjectValues.groundY && !collideHole) {
      debugPrint('jumpSpeed=$jumpSpeed');
      jumpSpeed = -200;
    }
  }

  SpriteAnimation _getAnimation(List<List<double>> list) {
    return SpriteAnimation.spriteList(
      list
          .map((e) => Sprite(
                game.images.fromCache('mario/item_objects.png'),
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: 0.1,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Hole && (x > other.x || x + width < other.x + other.width)) {
      collideHole = true;
    }
  }
}

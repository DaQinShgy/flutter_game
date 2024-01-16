import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/mario/constants/hit_edge.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/ground_block.dart';
import 'package:flutter_game/mario/util/collision_util.dart';

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

  int horizontalDirection;

  double jumpSpeed = 0;

  bool _fired = false;

  bool get fired => _fired;

  @override
  FutureOr<void> onLoad() {
    animation = _getAnimation(flyVector);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (horizontalDirection == 0) {
      return;
    }
    x += ObjectValues.fireBallSpeed * horizontalDirection * dt;
    jumpSpeed += ObjectValues.fireBallGravityAccel * dt;
    y += jumpSpeed * dt;
  }

  SpriteAnimation _getAnimation(List<List<double>> list, {bool loop = true}) {
    return SpriteAnimation.spriteList(
      list
          .map((e) => Sprite(
                game.images.fromCache('mario/item_objects.png'),
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: 0.1,
      loop: loop,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is GroundBlock) {
      HitEdge hitEdge = CollisionUtil.getHitEdge(intersectionPoints, other);
      if (hitEdge == HitEdge.top) {
        jumpSpeed = -200;
      } else {
        if (horizontalDirection != 0) {
          horizontalDirection = 0;
          animation = _getAnimation(explodeVector, loop: false);
          _fired = true;
          animationTicker?.onComplete = () {
            removeFromParent();
          };
        }
      }
    } else if (other is PowerupFireball) {
    } else {
      if (horizontalDirection != 0) {
        horizontalDirection = 0;
        animation = _getAnimation(explodeVector, loop: false);
        _fired = true;
        animationTicker?.onComplete = () {
          removeFromParent();
        };
      }
    }
  }
}

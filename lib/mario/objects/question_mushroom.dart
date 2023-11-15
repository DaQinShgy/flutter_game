import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';

class QuestionMushroom extends SpriteComponent
    with HasGameRef<MarioGame>, CollisionCallbacks {
  QuestionMushroom({super.position, super.priority = -1});

  // Vector of mushroom
  List<double> mushroomVector = [0, 0, 16, 16];

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('mario/item_objects.png'),
      srcPosition: Vector2(mushroomVector[0], mushroomVector[1]),
      srcSize: Vector2(mushroomVector[2], mushroomVector[3]),
    );
    add(RectangleHitbox());

    add(MoveByEffect(
      Vector2(0, -16),
      LinearEffectController(0.6),
      onComplete: () {
        horizontalDirection = 1;
      },
    ));
  }

  int horizontalDirection = 0;

  double jumpSpeed = 0;

  bool get isOnGround => (y >= 48);

  @override
  void update(double dt) {
    super.update(dt);
    x += ObjectValues.mushroomMoveSpeed * horizontalDirection * dt;
    debugPrint('x=$x,y=$y');
    if (x >= 64 && !isOnGround) {
      jumpSpeed += ObjectValues.mushroomGravityAccel * dt;
      y += jumpSpeed * dt;
    }
    if (isOnGround) {
      y = 48;
    }
    if (parent != null &&
        (parent as PositionComponent).x + x + width <
            game.cameraComponent.viewfinder.position.x) {
      // Mushroom moves off left screen edge
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ColliderBlock) {
      horizontalDirection = -1;
    } else if (other is MarioPlayer) {
      removeFromParent();
    }
  }
}
